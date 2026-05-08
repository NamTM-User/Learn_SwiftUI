//
//  FrameTop.swift
//  PraticeSwiftUI
//
//  Created by Hai Nam on 5/5/26.
//

import SwiftUI

struct FrameTop: View {
    
    // update
    private var titleView: some View {
        VStack(alignment: .leading) {
            Text("Compare")
            Text("Images")
        }
        .font(.system(size: 49, weight: .bold))
    }

    var body: some View {
        HStack(alignment: .top) {
            // TODO: use mask instead of foregroundstyle => DONE
            titleView
                .foregroundColor(.red)
                // Dùng overlay phủ lên view để không phá layout
                .overlay {
                    RadialGradient(
                        colors: [
                            Color(hex: "FFFFFF"),
                            Color(hex: "5700E4")
                        ],
                        center: UnitPoint(x: 0.9, y: 0),
                        startRadius: 0,
                        endRadius: 180
                    )
                    .frame(width: 250, height: 150)
                    .mask { titleView }
                }

            // Slice
            Spacer()
            // Circle
            Circle().fill(Color(hex: "8563FF")).frame(width: 44, height: 44)
            
        }
    }
}

#Preview {
    ZStack {
           
           VStack {
               FrameTop()
                   .padding(.top, 60)
               Spacer()
           }
       }
    .background(.black)
    
}
