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
    
    var body: some View {
        HStack {
            Spacer()
            
            Button {
                // code back
                canvasModel.saveChanges()
                
                dismiss()
                
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
    ProjectDetailHeader()
}
