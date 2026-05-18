//
//  ProjectDetailHeader.swift
//  Test1
//
//  Created by Hai Nam on 15/5/26.
//

import SwiftUI

struct ProjectDetailHeader: View {
    var body: some View {
        HStack {
            Button {
                // code back
            } label: {
                Text("Back")
                    .foregroundStyle(.black)
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}

#Preview {
    ProjectDetailHeader()
}
