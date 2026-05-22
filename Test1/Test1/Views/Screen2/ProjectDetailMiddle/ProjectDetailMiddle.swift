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
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
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
