//
//  PhotoSelectionOverlay.swift
//  Test1
//
//  Created by Hai Nam on 22/5/26.
//

import SwiftUI

struct PhotoSelectionOverlay: View {
    let photo: Photo
    var onDelete: () -> Void

    var body: some View {
        let transform = photo.transform
        // image sau khi scale
        let halfWidth = (transform.baseSize.width  * transform.scale) / 2
        let halfHeight = (transform.baseSize.height * transform.scale) / 2

        // dot
        let topLeft = calculateCanvasPoint(centerX: transform.center.x, centerY: transform.center.y, offsetX: -halfWidth, offsetY: -halfHeight, angle: transform.rotation)
        let topRight = calculateCanvasPoint(centerX: transform.center.x, centerY: transform.center.y, offsetX:  halfWidth, offsetY: -halfHeight, angle: transform.rotation)
        let bottomLeft = calculateCanvasPoint(centerX: transform.center.x, centerY: transform.center.y, offsetX: -halfWidth, offsetY:  halfHeight, angle: transform.rotation)
        let bottomRight = calculateCanvasPoint(centerX: transform.center.x, centerY: transform.center.y, offsetX:  halfWidth, offsetY:  halfHeight, angle: transform.rotation)

        // button delete
        let deleteButton = calculateCanvasPoint(centerX: transform.center.x, centerY: transform.center.y, offsetX: 0, offsetY: -halfHeight - 30, angle: transform.rotation)

        ZStack {
            SelectionBorderView(
                topLeft: topLeft, topRight: topRight,
                bottomLeft: bottomLeft, bottomRight: bottomRight
            )

            ControlDot(position: topLeft)
            ControlDot(position: topRight)
            ControlDot(position: bottomLeft)
            ControlDot(position: bottomRight)

            DeleteButtonView(
                position: deleteButton,
                angle: Angle(radians: transform.rotation),
                action: onDelete
            )
        }
        .frame(width: CanvasSize.width, height: CanvasSize.height)
        .allowsHitTesting(true)
    }

    
    private func calculateCanvasPoint(centerX: Double, centerY: Double, offsetX: Double, offsetY: Double, angle: Double) -> CGPoint {
        let transform = CGAffineTransform(translationX: centerX, y: centerY)
            .rotated(by: angle)
        return CGPoint(x: offsetX, y: offsetY).applying(transform)
    }
}

// MARK: - Sub-components

struct ControlDot: View {
    let position: CGPoint
    var body: some View {
        Circle()
            .fill(Color.white)
            .shadow(radius: 2)
            .frame(width: 14, height: 14)
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            .position(position)
            .allowsHitTesting(false)
    }
}

struct SelectionBorderView: View {
    let topLeft: CGPoint
    let topRight: CGPoint
    let bottomLeft: CGPoint
    let bottomRight: CGPoint

    var body: some View {
        Path { path in
            path.move(to: topLeft)
            path.addLine(to: topRight)
            path.addLine(to: bottomRight)
            path.addLine(to: bottomLeft)
            path.closeSubpath()
        }
        .stroke(Color.blue, style: StrokeStyle(lineWidth: 2))
        .allowsHitTesting(false)
    }
}

struct DeleteButtonView: View {
    let position: CGPoint
    let angle: Angle
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color(red: 1.0, green: 0.27, blue: 0.27))
                    .frame(width: 32, height: 32)
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 14, height: 3)
                    .cornerRadius(1.5)
            }
        }
        .rotationEffect(angle)
        .position(position)
    }
}
