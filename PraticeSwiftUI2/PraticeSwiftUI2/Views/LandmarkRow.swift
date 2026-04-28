//
//  LandmarkRow.swift
//  PraticeSwiftUI2
//
//  Created by Hai Nam on 28/4/26.
//

import SwiftUI

struct LandmarkRow: View {
    var landmark: Landmark
    var body: some View {
        HStack{
            landmark.image.resizable().frame(width: 50,height: 50)
            
            //
            Text(landmark.name)
            //
            Spacer()
        }
    }
}

#Preview {
    Group{
        LandmarkRow(landmark: landmarks[0])
        LandmarkRow(landmark: landmarks[1])
        LandmarkRow(landmark: landmarks[2])
    }
}


