//
//  ProjectDetailView.swift
//  Test1
//
//  Created by Hai Nam on 14/5/26.
//

import SwiftUI

struct ProjectDetailView: View {
    
    @State private var canvasModel = CanvasModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            // top
            ProjectDetailHeader()
            
            // mid
            ProjectDetailMiddle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.9, green: 0.95, blue: 1.0))
            
            // bot
            ProjectDetailBottom {
                print("ok")
            }
        }
        .environment(canvasModel)
    }
}

#Preview {
    ProjectDetailView()
}
