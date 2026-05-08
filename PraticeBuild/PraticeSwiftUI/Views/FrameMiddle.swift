//
//  FrameMiddle.swift
//  PraticeSwiftUI
//
//  Created by Hai Nam on 5/5/26.
//
import SwiftUI

struct Slider: View {
    // 1. Vi tri hien tai cua View luc Drag
    @Binding var offset: CGSize
    // 2. Vi tri cuoi cung khi ket thuc Drag
    @State private var lastOffset: CGSize = CGSize(width: 0, height: 0)
    
    var body: some View {
        GeometryReader { geo in
            let spacing: CGFloat = 5
            
            // size parent
            let parentWidth: CGFloat = geo.size.width
            let parentHeight: CGFloat = geo.size.height

            
            //size slider
            let sliderWidth: CGFloat = 23
            let sliderHeight: CGFloat = 35
            
            // Tinh toan gioi han bien parent
            let maxOffsetX = max(0, (parentWidth - sliderWidth) / 2)
            let maxOffsetY = max(0, (parentHeight - sliderHeight) / 2 - spacing)
            
            // Tinh toan toa do cua slider so voi View parent
            let sliderX = (parentWidth / 2) + offset.width
            let sliderY = (parentHeight / 2) + offset.height
            
            // Chieu cao 2 thanh doc
            let topHeight = max(0, sliderY - (sliderHeight / 2) - spacing)
            let botHeight = max(0, parentHeight - sliderY - (sliderHeight / 2) - spacing)
            
            
            VStack(spacing: spacing){
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
//            .animation(.interactiveSpring(response: 0.2, dampingFraction: 0.9), value: offset)
        }
    }
}


struct FrameMiddle: View {
    @Binding var imageA: UIImage?
    @Binding var imageB: UIImage?
    
    @State private var sliderOffset: CGSize = CGSize(width: 0, height: 0)

    private let frameWidth: CGFloat = 362
    private let frameHeight: CGFloat = 486
    private let cornerRadius: CGFloat = 30

    var body: some View {
        ZStack(alignment: .top) {
            // BACKGROUND
            Color.black
            
            // image B full image khong cat
            if let imgB = imageB {
                Image(uiImage: imgB)
                    .resizable()
                    .scaledToFill()
                    .frame(width: frameWidth, height: frameHeight)
                    .clipped()
            }
            
            // image A dung mask de che
            if let imgA = imageA {
                
                let maskWidth = (frameWidth / 2) + sliderOffset.width
                
                Image(uiImage: imgA)
                    .resizable()
                    .scaledToFill()
                    .frame(width: frameWidth, height: frameHeight)
                    .mask(
                        Rectangle()
                            .frame(width: max(0, maskWidth) , height: frameHeight)
                            .frame(width: frameWidth, alignment: .leading)
                    )
            }


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
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.black)
                    .stroke(Color(hex: "8563FF"), lineWidth: 2)
            )
            .padding(.top, 10)
            .padding(.horizontal, 96)
            .zIndex(1)

            // ----------------------------Slider------------------------------------
            Slider(offset: $sliderOffset).frame(width: frameWidth, height: frameHeight)
            
            
        }
        .frame(width: frameWidth, height: frameHeight)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color(hex: "8563FF"), lineWidth: 2)
        )
    }
}


#Preview {
    FrameMiddle(imageA: .constant(nil), imageB: .constant(nil))
}

