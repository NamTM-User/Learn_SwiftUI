//
//  FrameMiddle.swift
//  PraticeSwiftUI
//
//  Created by Hai Nam on 5/5/26.
//
import SwiftUI

struct Slider: View {
    // 1. Vi tri hien tai cua View luc Drag
    @State private var offset: CGSize = CGSize(width: 0, height: 0)
    // 2. Vi tri cuoi cung khi ket thuc Drag
    @State private var lastOffset: CGSize = CGSize(width: 0, height: 0)
    
    var body: some View {
        GeometryReader { geo in
            // size parent
            let parentWidth: CGFloat = geo.size.width
            let parentHeight: CGFloat = geo.size.height
            
            //size slider
            let sliderWidth: CGFloat = 23
            let sliderHeight: CGFloat = 35
            
            // Tinh toan gioi han bien parent
            let maxOffsetX = max(0, (parentWidth - sliderWidth) / 2)
            let maxOffsetY = max(0, (parentHeight - sliderHeight) / 2 - 5)
            
            // Tinh toan toa do cua slider so voi View parent
            let sliderX = (parentWidth / 2) + offset.width
            let sliderY = (parentHeight / 2) + offset.height
            
            // Chieu cao 2 thanh doc
            let topHeight = max(0, sliderY - (sliderHeight / 2) - 5) 
            let botHeight = max(0, parentHeight - sliderY - (sliderHeight / 2) - 5)
            
            
            VStack(spacing: 5){
                //1.
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "8563FF"))
                    .frame(width: 2 , height: topHeight)
                //2
                Capsule()
                    .fill(Color.white)
                    .frame(width: sliderWidth, height: sliderHeight)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0 , y: 1)
                //3
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "8563FF"))
                    .frame(width: 2, height: botHeight)
            }
            // tong chieu cao vstack luon = chieu cao cua geo.size.height
            .position(x: sliderX , y: parentHeight / 2)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let newX = lastOffset.width + value.translation.width
                        let newY = lastOffset.height + value.translation.height
                        
                        offset = CGSize(
                            width: min(max(newX, -maxOffsetX), maxOffsetX),
                            height: min(max(newY, -maxOffsetY), maxOffsetY)
                        )
                    }
                    .onEnded { _ in
                        lastOffset = offset
                    }
            )
            .animation(.interactiveSpring(response: 0.2, dampingFraction: 0.9), value: offset)
        }
    }
}
struct FrameMiddle: View {
    var body: some View {
        ZStack(alignment: .top) {
            // BACKGROUND
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.black)
                .frame(width: 362, height: 486)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color(hex: "8563FF"), lineWidth: 2)
                )
                
            
            // Title
            VStack {
                Text("COMPARE")
                    .font(.system(size: 12.63, weight: .semibold))
                    .fixedSize()
                    .foregroundStyle(Color(hex: "8563FF"))
                    .padding(.horizontal, 57)
                    .padding(.vertical, 9)
            }
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.black)
                    .stroke(Color(hex: "8563FF" ), lineWidth: 2)
            )
            .padding(.top , 10)
            .padding(.horizontal , 96)
            .zIndex(1)
            
            // slider
           Slider().frame(width: 362, height: 486)
            
        }
    }
}


#Preview {
    FrameMiddle()
}

