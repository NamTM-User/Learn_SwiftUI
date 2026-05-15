//
//  ProjectDetailView.swift
//  Test1
//
//  Created by Hai Nam on 14/5/26.
//

import SwiftUI

struct ProjectDetailView: View {
    var body: some View {
        VStack {
            ProjectDetailHeader()
            ProjectDetailMiddle()
            ProjectDetailBottom()
        }
    }
}

#Preview {
    ProjectDetailView()
}
