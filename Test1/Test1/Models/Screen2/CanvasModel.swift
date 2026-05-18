//
//  Canvas.swift
//  Test1
//
//  Created by Hai Nam on 14/5/26.
//

import Foundation
import Combine
import Observation

@Observable
class CanvasModel {
    // state project list
    var projectDetail: ProjectDetail?
    // state selected
    var selectedPhotoIndex: Int?
    
    // api
    private let apiService = APIService()
    
    // 1. fetch
    func fetchData(_ id: Int) async throws {
        
        do {
            let data = try await apiService.postAPI(projectId: id)
            self.projectDetail = data
        } catch {
            throw error
        }
    }
    
    // ===================================== logic feature =======================================
    
    // 2. add photo
    func addPhoto(url: String, imgW: CGFloat, imgH: CGFloat , canvasSize: CGSize) {
        
        // image render center
        let x = (Double(canvasSize.width) - imgW) / 2
        let y = (Double(canvasSize.height) - imgH) / 2
        
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
                
                // delete
                self.projectDetail?.photos.remove(at: selectPhotoIdx)
                
                // go~ bo trang thai dang select
                self.selectedPhotoIndex = nil
                
            }
        }
    }
    
    // 4. Save & back
    func saveChanges() {
        
    }
    
    
    
    // ==================================== logic gestures =======================================
    
    // 5. move photo
    func movePhoto(index: Int, newX: Double, newY: Double) {
        
        self.projectDetail?.photos[index].frame.x = newX
        self.projectDetail?.photos[index].frame.y = newY
    }
    
    // 6. rotate photo
    func rotatePhoto() {
        
    }
    
    // 7. zoom
    func zoom(index: Int, newW:Double, newH: Double) {
        
        self.projectDetail?.photos[index].frame.width = newW
        self.projectDetail?.photos[index].frame.height = newH
    }
    
    
}
