//
//  ContentView.swift
//  PraticeSwiftUI
//
//  Created by Hai Nam on 5/5/26.
//

import SwiftUI

struct ContentView: View {
    @State private var imageA = UIImage(named: "image 1")
    @State private var imageB = UIImage(named: "image 2")

    var body: some View {
        ZStack {
            // Background
            Color.black
                .ignoresSafeArea()
            
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#8563FF").opacity(0.4),
                    Color.clear
                ]),
                center: .topLeading,
                startRadius: 100,
                endRadius: 600
            )
            .ignoresSafeArea()

            // main
            VStack {
                FrameTop()
                    .padding(.top, 20)
                
                FrameMiddle(imageA: $imageA, imageB: $imageB)
                    .padding()
                
                FrameBot(imageA: $imageA, imageB: $imageB)
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    ContentView()
}
