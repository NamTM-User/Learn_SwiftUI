//
//  ProjectDetailHeader.swift
//  Test1
//
//  Created by Hai Nam on 15/5/26.
//

import SwiftUI

struct ProjectDetailHeader: View {
    @Environment(CanvasModel.self) private var canvasModel
    @Environment(\.dismiss) private var dismiss
    
    let canvasSize: CGSize
    
    var body: some View {
        HStack {
            Spacer()
            
            Button {
                Task {
                    // 1 . Tạo ảnh từ Canvas
                    guard let img = canvasModel.renderCanvasImage(canvasSize: canvasSize) else {
                        return
                    }
                    
                    do {
                        // 2. save img
                        try await PhotoLibrarySaver.save(image: img)
                        
                        canvasModel.saveChanges()
                        dismiss()
                    } catch {
                        print("Lỗi: \(error)")
                    }
                }
                
            } label: {
                
                Text("Save")
                    .foregroundStyle(.black)
            }
            
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}

#Preview {
    ProjectDetailHeader(canvasSize: CGSize(width: 300, height: 400))
}
