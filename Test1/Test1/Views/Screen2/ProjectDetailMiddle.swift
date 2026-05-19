//
//  ProjectDetailMiddle.swift
//  Test1
//
//  Created by Hai Nam on 15/5/26.
//

import SwiftUI

struct ProjectDetailMiddle: View {
    @Environment(CanvasModel.self) private var canvasModel
    
    // State cho Zoom & Move toàn bộ Canvas
    @State private var canvasScale: CGFloat = 1.0
    @State private var lastCanvasScale: CGFloat = 1.0
    @State private var canvasOffset: CGSize = .zero
    @State private var lastCanvasOffset: CGSize = .zero
    
    var body: some View {
        // container
        ZStack {
            // 1. Lớp nền ảo để hứng Gesture (khi tap hoặc vuốt ra ngoài ảnh)
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    // Bỏ chọn ảnh nếu bấm ra ngoài
                    canvasModel.selectedPhotoIndex = nil
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            canvasOffset = CGSize(
                                width: lastCanvasOffset.width + value.translation.width,
                                height: lastCanvasOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            lastCanvasOffset = canvasOffset
                        }
                )
                .simultaneousGesture(
                    MagnifyGesture()
                        .onChanged { value in
                            canvasScale = lastCanvasScale * value.magnification
                        }
                        .onEnded { _ in
                            lastCanvasScale = canvasScale
                        }
                )
            
            // 2. Vùng chứa các bức ảnh
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
                                onZoom: { newW, newH in
                                    canvasModel.zoom(index: index, newW: newW, newH: newH)
                                },
                                onRotate: { angle in
                                    canvasModel.rotatePhoto(index: index, angle: angle)
                                },
                                onDelete: {
                                    canvasModel.deletePhoto()
                                }
                            )
                            .zIndex(isSelected ? 1 : 0)
                        }
                    }
                }
            }
            .coordinateSpace(name: "Canvas") // Name tự đặt tên theo ngữ cảnh 
            .scaleEffect(canvasScale)
            .offset(canvasOffset)
    //        .clipped()
        }
    }
}

// ==================================
struct PhotoItemView: View {
    let photo: Photo
    let isSelect: Bool
    
    // gesture
    let onTap: () -> Void
    let onMove: (Double, Double) -> Void
    let onZoom: (Double, Double) -> Void
    let onRotate: (Double) -> Void
    let onDelete: () -> Void
    
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
//            Image(.AA)
//                .resizable()
//                .scaledToFit()
            .frame(width: photo.frame.width , height: photo.frame.height)
            .clipped()
            .overlay {
                if isSelect {
                    ZStack {
                        // 1. Viền xanh
                        Rectangle()
                            .stroke(Color.blue, lineWidth: 2)
                        
                        // 2. dot
                        dot.offset(x: -6, y: -6).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        dot.offset(x: 6, y: -6).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        dot.offset(x: -6, y: 6).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        dot.offset(x: 6, y: 6).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        
                        // 3. button delete
                        Button(action: {
                            onDelete()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 1.0, green: 0.35, blue: 0.35))
                                    .frame(width: 32, height: 32)
                                
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 14, height: 3)
                                    .cornerRadius(1.5)
                            }
                        }
                        .offset(y: -40)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                }
            }
            }
        //
            .scaleEffect(scaleImage)
            .rotationEffect(Angle(degrees: photo.rotation ?? 0) + rotateImage)
            // ================================= gesture ===============================
            // 1. tap
            .onTapGesture {
                onTap()
            }
            // 2. move
            .gesture(
                DragGesture(coordinateSpace: .named("Canvas"))
                    .onChanged { value in
                        // chỉ chạy khi ảnh được chọn
                        guard isSelect else {
                            return
                        }
                        
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        guard isSelect else {
                            return
                        }
                        
                        let newX = photo.frame.x + value.translation.width
                        let newY = photo.frame.y + value.translation.height
                        
                        //reset
                        dragOffset = .zero
                        onMove(newX , newY)
                    }
            )
            // 3. zoom
            .simultaneousGesture(
                MagnifyGesture()
                    .onChanged { value in
                        // chỉ chạy khi ảnh được chọn
                        guard isSelect else {
                            return
                        }
                        scaleImage = value.magnification
                    }
                    .onEnded { value in
                        guard isSelect else {
                            return
                        }
                        // 1. tinh toan lai chieu widght va height new
                        let newW = photo.frame.width * value.magnification
                        let newH = photo.frame.height * value.magnification
                        
                        scaleImage = 1
                        onZoom(newW , newH)
                    }
            )
            // 4. rotate
            .simultaneousGesture(
                RotateGesture()
                    .onChanged { value in
                        // chỉ chạy khi ảnh được chọn
                        guard isSelect else {
                            return
                        }
                        rotateImage = value.rotation
                    }
                    .onEnded { value in
                        guard isSelect else {
                            return
                        }
                        let curRotation = photo.rotation ?? 0
                        let newRotation = curRotation + value.rotation.degrees
                        
                        onRotate(newRotation)
                        // reset
                        rotateImage = .zero
                        
                    }
            )
            .position(
                x: photo.frame.x + dragOffset.width,
                y: photo.frame.y + dragOffset.height
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
