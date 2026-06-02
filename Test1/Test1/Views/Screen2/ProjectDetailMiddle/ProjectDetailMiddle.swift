//
//  ProjectDetailMiddle.swift
//  Test1
//
//  ProjectDetailMiddle.swift
//  Test1
//
//  Created by Hai Nam on 15/5/26.
//

import SwiftUI

// MARK: - Container

struct ProjectDetailMiddle: View {
    @Environment(CanvasModel.self) private var canvasModel
    
    var body: some View {
        GeometryReader { geo in
            CanvasScrollView(
                size: geo.size,
                onSetup: { sv, cv in
                    canvasModel.scrollView       = sv
                    canvasModel.canvasContentView = cv
                    
                    Task {
                        await MainActor.run {
                            canvasModel.focusCamera()
                        }
                    }
                },
                viewSwiftUI: AnyView(
                    PhotoLayerView()
                        .environment(canvasModel)
                )
            )
        }
    }
}

// MARK: - Photo Layer

struct PhotoLayerView: View {
    @Environment(CanvasModel.self) private var canvasModel
    
    var body: some View {
        ZStack {
            // Background: tap để bỏ chọn ảnh
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    canvasModel.selectedPhotoIndex = nil
                }
            
            // Render từng ảnh
            if let detail = canvasModel.projectDetail {
                ForEach(Array(detail.photos.enumerated()), id: \.element.id) { index, photo in
                    let isSelected = canvasModel.selectedPhotoIndex == index
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
                
                // Selection overlay (canvas coords)
                if let idx = canvasModel.selectedPhotoIndex,
                   idx >= 0, idx < detail.photos.count {
                    PhotoSelectionOverlay(
                        photo: detail.photos[idx],
                        onDelete: { canvasModel.deletePhoto() }
                    )
                    .zIndex(2)
                    .allowsHitTesting(true)
                }
            }
        }
        .frame(width: CanvasSize.width, height: CanvasSize.height)
    }
}


