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
        GeometryReader { geo in
            let screenCenter = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            
            ZStack {
                Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    canvasModel.selectedPhotoIndex = nil
                }
                .gesture(CanvasPanGesture { delta in
                    canvasModel.canvasOffset.width += delta.width
                    canvasModel.canvasOffset.height += delta.height
                })
                .gesture(CanvasPinchGesture { scaleDelta, focalPoint in
                    let oldScale = canvasModel.canvasScale
                    let newScale = oldScale * scaleDelta
                    canvasModel.canvasScale = newScale
                    
                    // Độ lệch = khoảng cách từ ngón tay đến tâm màn hình
                    let focalX = focalPoint.x - screenCenter.x
                    let focalY = focalPoint.y - screenCenter.y
                    
                    // Tính lại offset mới bằng cách bù trừ đúng bằng sự giãn nở do scale
                    canvasModel.canvasOffset.width = focalX - (focalX - canvasModel.canvasOffset.width) * scaleDelta
                    canvasModel.canvasOffset.height = focalY - (focalY - canvasModel.canvasOffset.height) * scaleDelta
                })
            
            ZStack {
                if let detail = canvasModel.projectDetail {
                    
                    ForEach(detail.photos) { photo in
                        if let index = detail.photos.firstIndex(where: { $0.id == photo.id }) {
                            let isSelected = (canvasModel.selectedPhotoIndex == index)
                            
                            PhotoItemView(
                                photo: photo,
                                index: index,
                                isSelect: isSelected,
                                onTap: {
                                    if canvasModel.selectedPhotoIndex != index {
                                        canvasModel.selectedPhotoIndex = index
                                    }
                                }
                            )
                            .zIndex(isSelected ? 1 : 0)
                        }
                    }
                    
                    // Viền  + chấm + nút xoá
                    if let selectedIndex = canvasModel.selectedPhotoIndex,
                       selectedIndex >= 0,
                       selectedIndex < detail.photos.count {
                        PhotoSelectionOverlay(
                            photo: detail.photos[selectedIndex],
                            canvasScale: canvasModel.canvasScale,
                            onDelete: {
                                canvasModel.deletePhoto()
                            }
                        )
                        .zIndex(2)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(canvasModel.canvasScale)
            .offset(canvasModel.canvasOffset)
        }
        .frame(width: geo.size.width, height: geo.size.height)
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
