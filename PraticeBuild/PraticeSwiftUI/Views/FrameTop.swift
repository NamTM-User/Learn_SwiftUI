//
//  FrameTop.swift
//  PraticeSwiftUI
//
//  Created by Hai Nam on 5/5/26.
//

import SwiftUI

struct FrameTop: View {
    
    var body: some View {
        HStack (alignment: .top){
            //Text
            VStack(alignment: .leading, spacing: -5) {
                // text1
                Text("Compare")
                
                // text2
                Text("Images")
            }
            .foregroundStyle(RadialGradient(
                colors: [Color(hex: "FFFFFF"), Color(hex: "5700E4")],
                center: UnitPoint(x: 0.9, y: 0.8),
                startRadius: 0,
                endRadius: 50
            ))
            .font(.system(size: 49.33 , weight: .bold))
            .fixedSize()

            // Slice
            Color.clear.frame(width: 100, height: 100)
            // Circle
            Circle().fill(Color(hex: "8563FF")).frame(width: 44, height: 44)
            
        }
        .frame(width: 362, height: 118)
    }
}

#Preview {
    ZStack {
           Color(hex: "0B001A").ignoresSafeArea()
           
           VStack {
               FrameTop()
                   .padding(.top, 60)
               Spacer()
           }
       }
    
}
