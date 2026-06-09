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
            ZStack {
                // 1. MARK: - Canvas ScrollView
                CanvasScrollView(
                    size: geo.size,
                    onSetup: { sv, cv in
                        canvasModel.scrollView        = sv
                        canvasModel.canvasContentView = cv
                    },
                    onZoom: {
                        canvasModel.overlayView?.updatePosition(model: canvasModel)
                    },
                    onScroll: {
                        canvasModel.overlayView?.updatePosition(model: canvasModel)
                    },
                    viewSwiftUI: AnyView(
                        PhotoContentLayer()
                            .frame(width: CanvasSize.width, height: CanvasSize.height)
                            .clipped() // edit
                            .environment(canvasModel)
                    )
                )
                
                // 2. MARK: - OverlayUIView
                OverlayPhotoSeclection(canvasModel: canvasModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .clipped() 
            .onChange(of: geo.size) {
                canvasModel.overlayView?.updatePosition(model: canvasModel)
            }
        }
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
