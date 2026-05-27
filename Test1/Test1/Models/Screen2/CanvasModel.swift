//
//  Canvas.swift
//  Test1
//
//  Created by Hai Nam on 14/5/26.
//

import Foundation
import Combine
import SwiftUI
import UIKit

@Observable
class CanvasModel {
    // state project list
    var projectDetail: ProjectDetail?
    // state selected
    var selectedPhotoIndex: Int?
    
    // Cache lưu trữ ảnh local tải từ máy
    var localImages: [String: UIImage] = [:]
    
    // State cho Zoom & Move toàn bộ Canvas
    var canvasScale: CGFloat = 1.0
    var canvasOffset: CGSize = .zero
    
    // Tâm vùng Canvas trên màn hình
    var canvasAreaCenter: CGPoint = .zero
    
    // api
    private let apiService = APIService()
    
    // load image
    func loadImage(urlString: String) async throws -> Image {
        // 1. Tạo tên file an toàn cho ảnh từ mạng
        let safeImageName = urlString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
        
        // 2. Thử load ảnh từ local trước (nếu đã từng tải)
        if let savedImage = LocalFileManager.loadImage(imageName: safeImageName) {
            await MainActor.run {
                self.localImages[urlString] = savedImage
            }
            return Image(uiImage: savedImage)
        }
        
        // 3. Nếu chưa có local, tiến hành tải từ mạng
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        // 4. Lưu ảnh vừa tải xuống
        LocalFileManager.saveImage(image: image, imageName: safeImageName)
        
        // Cache ảnh tải từ server vào thư viện localImages để dùng cho lúc Save ảnh
        await MainActor.run {
            self.localImages[urlString] = image
        }

        return Image(uiImage: image)
    }
    
    // 1. fetch
    func fetchData(_ id: Int) async throws {
        
        // A: check data ở local trước
        if let localProject = LocalFileManager.loadProject(projectId: id) {
            self.projectDetail = localProject
            
            for photo in localProject.photos {
                // Nếu url không phải link web (không bắt đầu bằng http) thì nó chính là tên file ảnh local
                if !photo.url.hasPrefix("http") {
                    if let savedImage = LocalFileManager.loadImage(imageName: photo.url) {
                        self.localImages[photo.url] = savedImage
                    }
                } else {
                    // Check xem ảnh web này đã có cache trong máy chưa
                    let safeImageName = photo.url.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
                    if let savedImage = LocalFileManager.loadImage(imageName: safeImageName) {
                        self.localImages[photo.url] = savedImage
                    }
                }
            }
            
            if !localProject.photos.isEmpty {
                return
            }
        }
        
        // B: Nếu A chưa có file , lấy data từ server
        do {
            let data = try await apiService.postAPI(projectId: id)
            self.projectDetail = data
            
            // save vào local
            LocalFileManager.saveProject(project: data)
            
            // 
            for photo in data.photos {
                if photo.url.hasPrefix("http") {
                    let safeImageName = photo.url.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
                    if let savedImage = LocalFileManager.loadImage(imageName: safeImageName) {
                        self.localImages[photo.url] = savedImage
                    }
                }
            }
        } catch {
            let fallbackProject = ProjectDetail(name: "new project", id: id, photos: [])
            self.projectDetail = fallbackProject
            LocalFileManager.saveProject(project: fallbackProject)
        }
    }
    
    // ===================================== logic feature =======================================
    
    // 2. add photo
    func addPhoto(url: String, imgW: CGFloat, imgH: CGFloat , canvasSize: CGSize) {
        
        // center canvas
        let screenCenterX = Double(canvasSize.width) / 2
        let screenCenterY = Double(canvasSize.height) / 2
        
        // Map tâm màn hình về tọa độ của Canvas (khử offset và scale)
        let canvasCenterX = screenCenterX - Double(self.canvasOffset.width / self.canvasScale)
        let canvasCenterY = screenCenterY - Double(self.canvasOffset.height / self.canvasScale)
        
        // Tọa độ TÂM của ảnh
        let x = canvasCenterX
        let y = canvasCenterY
        
        let newPhoto = Photo(
            url: url,
            frame: Frame(
                x: x,
                y: y,
                width: imgW,
                height: imgH
            )
        )
        
        self.projectDetail?.photos.append(newPhoto)
    }
    
    // 3. delete photo
    func deletePhoto() {
        
         // check xem co img dang dc chon
        guard let selectPhotoIdx = selectedPhotoIndex else {
            return
        }
        
        if let project = self.projectDetail {
            let photoLength = project.photos.count
            
            if selectPhotoIdx >= 0 && selectPhotoIdx < photoLength {
                
                // Lấy url
                let photoUrl = project.photos[selectPhotoIdx].url
                
                // delete
                self.projectDetail?.photos.remove(at: selectPhotoIdx)
                
                // Xoá ảnh khỏi ổ cứng
                self.localImages.removeValue(forKey: photoUrl)
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                
                if !photoUrl.hasPrefix("http") {
                    // Ảnh local
                    let fileUrl = paths[0].appendingPathComponent(photoUrl)
                    try? FileManager.default.removeItem(at: fileUrl)
                } else {
                    let safeImageName = photoUrl.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
                    let fileUrl = paths[0].appendingPathComponent(safeImageName)
                    try? FileManager.default.removeItem(at: fileUrl)
                }
                
                // go~ bo trang thai dang select
                self.selectedPhotoIndex = nil
                
            }
        }
    }
    
    // 4. Save & back
    func saveChanges() {
        if let project = self.projectDetail {
            LocalFileManager.saveProject(project: project)
        }
    }
    
    // 5. render canvas
    func renderCanvasImage(canvasSize: CGSize) -> UIImage? {
        // init render
        let render = UIGraphicsImageRenderer(size: canvasSize)
        
        guard let photos = self.projectDetail?.photos else { return nil }
        
        // vẽ để tạo ảnh
        let image = render.image { context in
            // vẽ gì trong này đều sẽ thành UIImage
            
            /*
             Hàm vẽ mặc định của apple chỉ cho phép vẽ ảnh theo phương thẳng đứng
             Cách duy nhất trong iOS để vẽ một bức ảnh nằm nghiêng (ví dụ nghiêng 45 độ) là  phải cầm cả tờ giấy xoay đi 45 độ, sau đó vẽ thẳng lên tờ giấy đã nghiêng đó.
             -> phải có .cgContext để có thể xoay được canvas (Apple chỉ hỗ trợ cho cấp độ .cgContext)
             */
            let cgContext = context.cgContext
            // 1. fill background canvas
            UIColor.white.setFill()
            cgContext.fill(CGRect(origin: .zero, size: canvasSize))
            
            // render image
            for photo in photos {
                // chỉ vẽ nếu img đã được load thành công
                
                guard let img = self.localImages[photo.url] else { continue }
                
                // save toạ độ hiện tại vào stack
                cgContext.saveGState()
                
                let centerX = CGFloat(photo.frame.x)
                let centerY = CGFloat(photo.frame.y)
                let w = CGFloat(photo.frame.width)
                let h = CGFloat(photo.frame.height)
                
                // A. Dịch hệ toạ độ về đúng tâm của ảnh
                cgContext.translateBy(x: centerX, y: centerY)
                
                // B. Xoay nghiêng hệ trục toạ độ
                let radian = CGFloat(photo.rotation ?? 0) * .pi / 180.0
                cgContext.rotate(by: radian)
                
                // C. vẽ ảnh
                let drawRect = CGRect(x: -w/2, y: -h/2, width: w, height: h)
                img.draw(in: drawRect)
                
                // reset về toạ độ gốc để vẽ img tiếp
                cgContext.restoreGState()
            }
        }
        
        return image
    }
    
    
    
    // ==================================== logic gestures =======================================
    
    // 6. drag
    func panPhoto(index: Int, delta: CGSize) {
        self.projectDetail?.photos[index].frame.x += Double(delta.width)
        self.projectDetail?.photos[index].frame.y += Double(delta.height)
    }
    
    // 7. zoom
    func pinchPhoto(index: Int, scale: Double, screenFocalPoint: CGPoint) {
        guard var photo = self.projectDetail?.photos[index] else { return }
        
        // 1. ngón tay
        let focalX = canvasAreaCenter.x + (screenFocalPoint.x - canvasAreaCenter.x - canvasOffset.width) / canvasScale
        let focalY = canvasAreaCenter.y + (screenFocalPoint.y - canvasAreaCenter.y - canvasOffset.height) / canvasScale
        
        // 2. Dịch chuyển tâm ảnh để điểm dưới ngón tay đứng yên
        //    Công thức: new_center = focalPoint + (old_center - focalPoint) * scaleDelta
        photo.frame.x = focalX + (photo.frame.x - focalX) * scale
        photo.frame.y = focalY + (photo.frame.y - focalY) * scale
        
        // 3. Scale kích thước ảnh
        photo.frame.width *= scale
        photo.frame.height *= scale
        
        self.projectDetail?.photos[index] = photo
    }
    
    // 8. rotate
    func rotatePhotoDelta(index: Int, angleRadians: Double, screenFocalPoint: CGPoint) {
        guard var photo = self.projectDetail?.photos[index] else { return }
        
        let current = photo.rotation ?? 0
        let degrees = angleRadians * 180.0 / .pi
        photo.rotation = current + degrees
        
        let focalX = canvasAreaCenter.x + (screenFocalPoint.x - canvasAreaCenter.x - canvasOffset.width) / canvasScale
        let focalY = canvasAreaCenter.y + (screenFocalPoint.y - canvasAreaCenter.y - canvasOffset.height) / canvasScale
        
        let dx = photo.frame.x - focalX
        let dy = photo.frame.y - focalY
        
        let cosA = cos(angleRadians)
        let sinA = sin(angleRadians)
        
        photo.frame.x = focalX + dx * cosA - dy * sinA
        photo.frame.y = focalY + dx * sinA + dy * cosA
        
        self.projectDetail?.photos[index] = photo
    }
    
    
    // =============================== test 2 ====================================
    // update Opacity
    func updateOpacity(index: Int , opacity: Double) {
        // check index
        guard let photos = self.projectDetail?.photos,
              index >= 0,
              index < photos.count else { return }
        
        self.projectDetail?.photos[index].opacity = opacity
    }
}
