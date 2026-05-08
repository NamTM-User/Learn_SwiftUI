//
//  ContentView.swift
//  Test
//
//  Created by Nam on 5/6/26.
//

import SwiftUI

struct Test: View {
    
    @State var sliderValue: CGFloat = 0.5
    @State var pointerOffset: CGFloat = 0.5
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Image("image 1")
                    .resizable().scaledToFill()
                    .frame(minWidth: 0, minHeight: 0)
                    .clipped()
                Image("image 2")
                    .resizable().scaledToFill()
                    .frame(minWidth: 0, minHeight: 0)
                    .clipped()
                    .mask {
                        GeometryReader { geo in
                            Rectangle().frame(
                                width: geo.size.width * sliderValue,
                                height: geo.size.height)
                        }
                    }
                
                GeometryReader { geo in
                    VStack(spacing: 10) {
                        Capsule().frame(width: 5, height: geo.size.height * pointerOffset - 30)
                        Capsule().frame(height: 50)
                            .gesture(
                                DragGesture()
                                    .onChanged({ value in
                                        sliderValue += value.translation.width / geo.size.width
                                        pointerOffset += value.translation.height / geo.size.height
                                    })
                            )
                        Capsule().frame(width: 5)
                    }
                    .foregroundStyle(.white)
                    .frame(width: 30)
                    .offset(x: -15 + geo.size.width * sliderValue)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(20)
        }
    }
}

#Preview {
    Test()
}
