//
//  ProjectDetailView.swift
//  Test1
//
//  Created by Hai Nam on 14/5/26.
//

import SwiftUI

struct ProjectDetailView: View {
    // testt
    let projectID: Int
    
    @State private var canvasModel = CanvasModel()
    @State private var canvasSize: CGSize = .zero
    
    var body: some View {
        VStack(spacing: 0) {
            
            // top
            ProjectDetailHeader()
            
            // mid
            ProjectDetailMiddle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.9, green: 0.95, blue: 1.0))
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear{
                                canvasSize = geo.size // save kích thước màn hình của thiết bị user
                            }
                            .onChange(of: geo.size) { _, newValue in
                                canvasSize = newValue
                            }
                    }
                )
                .clipped()
                
            
            // bot
            ProjectDetailBottom { image in
                if let img = UIImage(data: image){
                    let randomURL = UUID().uuidString
                    canvasModel.localImages[randomURL] = img
                    
                    let originalWidth = img.size.width
                    let originalHeight = img.size.height
                    let aspectRatio = originalWidth / originalHeight
                    
                    // Tính toán để ảnh chiếm tối đa 50% kích thước canvas
                    var displayWidth = canvasSize.width * 0.5
                    var displayHeight = displayWidth / aspectRatio
                    
                    if displayHeight > canvasSize.height * 0.5 {
                        displayHeight = canvasSize.height * 0.5
                        displayWidth = displayHeight * aspectRatio
                    }
                    
                    canvasModel.addPhoto(
                        url: randomURL, // random url
                        imgW: displayWidth,
                        imgH: displayHeight,
                        canvasSize: canvasSize
                    )
                }
            }
        }
        .environment(canvasModel)
        .task {
            do {
                try await canvasModel.fetchData(projectID)
            }
            catch {
                print(error)
            }
        }
    }
}

#Preview {
    ProjectDetailView(projectID: 21)
}
