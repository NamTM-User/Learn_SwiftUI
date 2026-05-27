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
            // 1. back
            Button {
                canvasModel.saveChanges()
                // đóng màn hình
                dismiss()
            } label: {
            Text("Back")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.black)
            }
            // 2. spacer
            Spacer()
            
            // 3. export
//            if let img = canvasModel.renderCanvasImage(canvasSize: canvasSize) {
//                ShareLink(
//                    item: Image(uiImage: img),
//                    preview: SharePreview("abcxyz", image: Image(uiImage: img))
//                ) {
//                    Text("export")
//                        .font(.system(size: 20, weight: .bold))
//                        .foregroundStyle(.blue)
//                }
//            } else {
//                Text("export")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundStyle(.blue)
//            }
            
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}
