//
//  ProfileHost.swift
//  PraticeSwiftUI2
//
//  Created by Hai Nam on 4/5/26.
//

import SwiftUI

struct ProfileHost: View {
    @Environment(\.editMode) var editMode
    @State private var draftProfile = Profile.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                Spacer()
                EditButton()
            }
            
            ProfileSummary(profile: draftProfile)
        
        }
        .padding()
    }
}

#Preview {
    ProfileHost().environment(ModelData())
}
