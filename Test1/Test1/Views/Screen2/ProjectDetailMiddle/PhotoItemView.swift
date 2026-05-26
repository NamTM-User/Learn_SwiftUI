//
//  PhotoItemView.swift
//  Test1
//
//  Created by Hai Nam on 21/5/26.
//

import SwiftUI

struct PhotoItemView: View {
    @Environment(CanvasModel.self) private var canvasModel
    
    let photo: Photo
    let index: Int
    let isSelect: Bool
    let onTap: () -> Void
    
    var body: some View {
        
        
        Group {
            if let localImg = canvasModel.localImages[photo.url] {
                Image(uiImage: localImg)
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
                    .task {
                        let _ = try? await canvasModel.loadImage(urlString: photo.url)
                    }
            }
        }
        .frame(width: photo.frame.width, height: photo.frame.height)
        .clipped()
        .rotationEffect(Angle(degrees: photo.rotation ?? 0))
        .position(x: photo.frame.x, y: photo.frame.y)
        .onTapGesture {
            onTap()
        }
        // gắn UIKit 
        .photoGestures(
            isSelected: isSelect,
            canvasScale: canvasModel.canvasScale,
            onPan: { delta in
                canvasModel.panPhoto(index: index, delta: delta)
            },
            onPinch: { scale, focalPoint in
                canvasModel.pinchPhoto(index: index, scale: scale, screenFocalPoint: focalPoint)
            },
            onRotate: { angle, focalPoint in
                canvasModel.rotatePhotoDelta(index: index, angleRadians: angle, screenFocalPoint: focalPoint)
            }
        )
    }
}
