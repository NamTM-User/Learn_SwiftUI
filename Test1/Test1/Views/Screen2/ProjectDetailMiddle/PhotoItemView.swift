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
    let isSelect: Bool
    
    // gesture
    let onTap: () -> Void
    let onMove: (Double, Double) -> Void
    let onZoom: (Double, Double) -> Void
    let onRotate: (Double) -> Void
    let onDelete: () -> Void
    
    // State
    @State private var loaderImage: Image?
    @State private var dragOffset: CGSize = .zero
    @State private var scaleImage: CGFloat = 1.0
    @State private var rotateImage: Angle = .zero
    
    private var dynamicScale: CGFloat {
        let scale = (photo.frame.width * scaleImage) / 350.0
        return max(0.6, scale) 
    }
    
    // view dot
    private var dot: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 12 * dynamicScale, height: 12 * dynamicScale)
    }
    
    var body: some View {
        //
        ZStack {
            // load image
            Group {
                if let localImg = canvasModel.localImages[photo.url] {
                    Image(uiImage: localImg)
                        .resizable()
                        .scaledToFill()
                } else if let image = loaderImage {
                    image.resizable().scaledToFill()
                }
                else {
                    ProgressView()
                        .task {
                            if let dowloadImage = try? await canvasModel.loadImage(urlString: photo.url) {
                                self.loaderImage = dowloadImage
                            }
                            
                        }
                }
            }
            .frame(width: photo.frame.width * scaleImage, height: photo.frame.height * scaleImage)
            .clipped()
            .overlay {
                if isSelect {
                    ZStack {
                        // 1. Viền xanh
                        Rectangle()
                            .stroke(Color.blue, lineWidth: 2 * dynamicScale)
                        
                        // 2. dot
                        let dOffset = 6 * dynamicScale
                        dot.offset(x: -dOffset, y: -dOffset).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        dot.offset(x: dOffset, y: -dOffset).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        dot.offset(x: -dOffset, y: dOffset).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        dot.offset(x: dOffset, y: dOffset).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        
                        Button(action: {
                            onDelete()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 1.0, green: 0.35, blue: 0.35))
                                    .frame(width: 32 * dynamicScale, height: 32 * dynamicScale)
                                
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 14 * dynamicScale, height: 3 * dynamicScale)
                                    .cornerRadius(1.5 * dynamicScale)
                            }
                        }
                        .frame(width: 32 * dynamicScale, height: 32 * dynamicScale)
                        .offset(y: -40 * dynamicScale)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                }
            }
            //
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
                x: photo.frame.x + (photo.frame.width / 2) + dragOffset.width,
                y: photo.frame.y + (photo.frame.height / 2) + dragOffset.height
            )
        }
    }
}
