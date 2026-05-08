//
//  FrameMiddle.swift
//  PraticeSwiftUI
//
//  Created by Hai Nam on 5/5/26.
//
import SwiftUI

struct Slider: View {
    @Binding var sliderRatio: CGPoint
    @State private var startRatio: CGPoint = CGPoint(x: 0.5, y: 0.5)

    private let sliderWidth:  CGFloat = 23
    private let sliderHeight: CGFloat = 35
    private let spacing:      CGFloat = 5

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            // Tọa độ pixel thực tế từ tỷ lệ
            let currentX = w * sliderRatio.x
            let currentY = h * sliderRatio.y

            // Chiều cao 2 thanh dọc co giãn theo vị trí Y
            let topH = max(0, currentY - sliderHeight / 2 - spacing)
            let botH = max(0, h - currentY - sliderHeight / 2 - spacing)

            VStack(spacing: spacing) {
                // Thanh line trên
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "8563FF"))
                    .frame(width: 2, height: topH)

                // Nút kéo
                Capsule()
                    .fill(Color.white)
                    .frame(width: sliderWidth, height: sliderHeight)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)

                // Thanh line dưới
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "8563FF"))
                    .frame(width: 2, height: botH)
            }
            .position(x: currentX, y: h / 2)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let newX = startRatio.x + value.translation.width  / w
                        let newY = startRatio.y + value.translation.height / h

                        sliderRatio = CGPoint(
                            x: min(max(newX, 0), 1),
                            y: min(max(newY, 0.05), 0.95)
                        )
                    }
                    .onEnded { _ in
                        startRatio = sliderRatio
                    }
            )
        }
    }
}

struct FrameMiddle: View {
    @Binding var imageA: UIImage?
    @Binding var imageB: UIImage?

    // Vị trí Slider mặc định ở giữa
    @State private var sliderRatio: CGPoint = CGPoint(x: 0.5, y: 0.5)

    private let cornerRadius: CGFloat = 30

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack(alignment: .top) {

                // 1. Background
                Color.black

                // 2. Image B
                if let imgB = imageB {
                    Image(uiImage: imgB)
                        .resizable()
                        .scaledToFill()
                        .frame(width: w, height: h)
                        .clipped()
                }

                // 3. Image A
                if let imgA = imageA {
                    Image(uiImage: imgA)
                        .resizable()
                        .scaledToFill()
                        .frame(width: w, height: h)
                        .clipped()
                        .mask(
                            GeometryReader { maskGeo in
                                Rectangle()
                                    .frame(width: maskGeo.size.width * sliderRatio.x)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        )
                }

                // 4. Title
                Text("COMPARE")
                    .font(.system(size: 12.63, weight: .semibold))
                    .foregroundStyle(Color(hex: "8563FF"))
                    .padding(.horizontal, 50)
                    .padding(.vertical, 9)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.black)
                            .stroke(Color(hex: "8563FF"), lineWidth: 2)
                    )
                    .padding(.top, 10)
                    .zIndex(2)

                // 5. -----------Slider--------------
                Slider(sliderRatio: $sliderRatio)
                    .zIndex(1)
            }
            .frame(width: w, height: h)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color(hex: "8563FF"), lineWidth: 2)
            )
        }
    }
}


#Preview {
    FrameMiddle(imageA: .constant(nil), imageB: .constant(nil))
}
