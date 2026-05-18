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
    
    // State
    @State private var dragOffset: CGSize = .zero
    
    // view dot
    private var dot: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 12 ,height: 12)
            .shadow(radius: 3)
    }
    
    var body: some View {
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
                        dot.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        dot.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        dot.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        dot.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        }
                    }
                } // làm sau
            }
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
