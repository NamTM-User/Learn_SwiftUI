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
    @State private var lastCanvasScale: CGFloat = 1.0
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
                            canvasModel.canvasOffset = CGSize(
                                width: lastCanvasOffset.width + value.translation.width,
                                height: lastCanvasOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            lastCanvasOffset = canvasModel.canvasOffset
                        }
                )
                .simultaneousGesture(
                    MagnifyGesture()
                        .onChanged { value in
                            canvasModel.canvasScale = lastCanvasScale * value.magnification
                        }
                        .onEnded { _ in
                            lastCanvasScale = canvasModel.canvasScale
                        }
                )
            
            // 2. Vùng chứa image
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .coordinateSpace(name: "Canvas") // Name tự đặt tên theo ngữ cảnh
            .scaleEffect(canvasModel.canvasScale)
            .offset(canvasModel.canvasOffset)
    //        .clipped()
        }
    }
}

// ==================================

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
