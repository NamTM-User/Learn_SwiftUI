//
//  ProjectDetailMiddle.swift
//  Test1
//
//  Created by Hai Nam on 15/5/26.
//

import SwiftUI

struct ProjectDetailMiddle: View {
    @Environment(CanvasModel.self) private var canvasModel
    
    var body: some View {
        ZStack {
            // unwrap
            if let detail = canvasModel.projectDetail {
                ForEach(detail.photos) { photo in
                    // index của image đang chọn
                    if let index = detail.photos.firstIndex(where: { $0.id == photo.id }) {
                        
                        let isSelected = (canvasModel.selectedPhotoIndex == index)
                        
                        PhotoItemView(
                            photo: photo,
                            isSelect: isSelected,
                            onTap: {
                                // Chỉ cập nhật khi chưa chọn
                                if canvasModel.selectedPhotoIndex != index {
                                    canvasModel.selectedPhotoIndex = index
                                }
                            },
                            onMove: { newX, newY in
                                canvasModel.movePhoto(index: index, newX: newX, newY: newY)
                            },
                            onZoom: { newW, newH, X, Y in
                                canvasModel.zoom(index: index, newW: newW, newH: newH, newX: X, newY: Y)
                            },
                            onRotate: { angle in
                                canvasModel.rotatePhoto(index: index, angle: angle)
                            }
                        )
                        .zIndex(isSelected ? 1 : 0)
                    }
                }
            }
        }
//        .clipped()
    }
}

// ==================================
struct PhotoItemView: View {
    let photo: Photo
    let isSelect: Bool
    
    // gesture
    let onTap: () -> Void
    let onMove: (Double, Double) -> Void
    let onZoom: (Double, Double, Double, Double) -> Void
    let onRotate: (Double) -> Void
    
    // State
    @State private var dragOffset: CGSize = .zero
    @State private var scaleImage: CGFloat = 1.0
    @State private var rotateImage: Angle = .zero
    
    // view dot
    private var dot: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 12 ,height: 12)
            .shadow(radius: 3)
    }
    
    var body: some View {
        //
        ZStack {
            // load image
            AsyncImage(url: URL(string: photo.url)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    ProgressView()
                }
            }
            .frame(width: photo.frame.width , height: photo.frame.height)
            .clipped()
            .overlay{
                if isSelect {
                    ZStack {
                        Rectangle()
                            .stroke(Color.blue, lineWidth: 2)
//                        dot.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//                        dot.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
//                        dot.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
//                        dot.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        }
                    }
                } // làm sau
            }
        //
            .scaleEffect(scaleImage)
            .rotationEffect(Angle(degrees: photo.rotation ?? 0) + rotateImage)
            .position(
                x: photo.frame.x + dragOffset.width,
                y: photo.frame.y + dragOffset.height
            )
            
            // ================================= gesture ===============================
            // 1. tap
            .onTapGesture {
                onTap()
            }
            // 2. move
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isSelect {
                            onTap()
                        }
                        
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        // Lấy vị trí x,y cũ cộng với tổng quãng đường ngón tay vừa vuốt
                        let newX = photo.frame.x + value.translation.width
                        let newY = photo.frame.y + value.translation.height
                        onMove(newX , newY)
                        //reset
                        dragOffset = .zero
                    }
            )
            // 3. zoom
            .simultaneousGesture(
                MagnifyGesture()
                    .onChanged { value in
                        scaleImage = value.magnification
                    }
                    .onEnded { value in
                        // 1. tinh toan lai chieu widght va height new
                        let newW = photo.frame.width * value.magnification
                        let newH = photo.frame.height * value.magnification
                        // 2
                        let X = photo.frame.x
                        let Y = photo.frame.y
                        
                        onZoom(newW , newH , X , Y)
                        scaleImage = 1
                    }
            )
            // 4. rotate
            .simultaneousGesture(
                RotateGesture()
                    .onChanged { value in
                        rotateImage = value.rotation
                    }
                    .onEnded { value in
                        let curRotation = photo.rotation ?? 0
                        let newRotation = curRotation + value.rotation.degrees
                        
                        onRotate(newRotation)
                        // reset
                        rotateImage = .zero
                        
                    }
            )
    }
}

#Preview {

    let liveModel = CanvasModel()

    return ProjectDetailMiddle()
        .environment(liveModel)
        
        .task {
            do {

                try await liveModel.fetchData(21)
            } catch {
                print("Lỗi tải API trong lúc Preview: \(error)")
            }
        }
}
