//
//  ProjectDetailMiddle.swift
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
                    canvasModel.scrollView        = sv
                    canvasModel.canvasContentView = cv
                    Task { @MainActor in
                        canvasModel.focusCamera()
                    }
                },
                onZoom: { zoomScale in
                    canvasModel.cameraZoom = zoomScale
                },
                viewSwiftUI: AnyView(
                    CanvasLayerView()
                        .environment(canvasModel)
                )
            )
        }
    }
}

// MARK: - Canvas Layer View
// Gộp cả 2 layer vào 1 UIHostingController duy nhất
// SwiftUI xử lý hit-testing đúng trong cùng 1 hosting

struct CanvasLayerView: View {
    var body: some View {
        ZStack {
            // Layer 1: Photos + canvas background — clip bằng SwiftUI .clipped()
            PhotoContentLayer()
                .frame(width: CanvasSize.width, height: CanvasSize.height)
                .clipped()

            // Layer 2: Selection overlay — KHÔNG clip, vẽ ra ngoài canvas được
            OverlayLayerView()
        }
        .frame(width: CanvasSize.width, height: CanvasSize.height)
    }
}

// MARK: - Photo Content Layer

struct PhotoContentLayer: View {
    @Environment(CanvasModel.self) private var canvasModel

    var body: some View {
        ZStack {
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
            }
        }
    }
}

// MARK: - Overlay Layer 

struct OverlayLayerView: View {
    @Environment(CanvasModel.self) private var canvasModel

    var body: some View {
        Group {
            if let idx = canvasModel.selectedPhotoIndex,
               let detail = canvasModel.projectDetail,
               idx >= 0, idx < detail.photos.count {
                PhotoSelectionOverlay(
                    photo: detail.photos[idx],
                    zoomScale: canvasModel.cameraZoom,
                    onDelete: { canvasModel.deletePhoto() }
                )
                .zIndex(2)
            }
        }
    }
}
