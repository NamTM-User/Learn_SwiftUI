//
//  ProjectDetailBottom.swift
//  Test1
//
//  Created by Hai Nam on 15/5/26.
//

import SwiftUI

struct ProjectDetailBottom: View {
    var onAddPhoto: () -> Void
    
    var body: some View {
        VStack {
            Button {
                onAddPhoto() // Gọi hành động khi nhấn
            } label: {
                Text("Add Photo")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 20)
        }
        .frame(height: 200)
        .background(Color(white: 0.98))
    }
}
