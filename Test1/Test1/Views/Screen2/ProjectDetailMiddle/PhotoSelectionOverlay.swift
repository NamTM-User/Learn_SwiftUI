//
//  PhotoSelectionOverlay.swift
//  Test1
//
//  Created by Hai Nam on 22/5/26.
//

import SwiftUI

struct PhotoSelectionOverlay: View {
    let photo: Photo
    let canvasScale: CGFloat
    var onDelete: () -> Void
    
    var body: some View {
        let cx = photo.frame.x
        let cy = photo.frame.y
        let hw = photo.frame.width / 2
        let hh = photo.frame.height / 2
        let angle = Angle(degrees: photo.rotation ?? 0).radians
        let topLeft     = rotatedPoint(cx: cx, cy: cy, dx: -hw, dy: -hh, angle: angle)
        let topRight    = rotatedPoint(cx: cx, cy: cy, dx:  hw, dy: -hh, angle: angle)
        let bottomLeft  = rotatedPoint(cx: cx, cy: cy, dx: -hw, dy:  hh, angle: angle)
        let bottomRight = rotatedPoint(cx: cx, cy: cy, dx:  hw, dy:  hh, angle: angle)
        
        let deletePos = rotatedPoint(cx: cx, cy: cy, dx: 0, dy: -hh - (35 / canvasScale), angle: angle)
        
        ZStack {
            // Viền xanh
            SelectionBorderView(
                topLeft: topLeft,
                topRight: topRight,
                bottomLeft: bottomLeft,
                bottomRight: bottomRight,
                canvasScale: canvasScale
            )
            
            // 4 dot
            ControlDot(position: topLeft, scale: canvasScale)
            ControlDot(position: topRight, scale: canvasScale)
            ControlDot(position: bottomLeft, scale: canvasScale)
            ControlDot(position: bottomRight, scale: canvasScale)
            
            // Nút xoá
            DeleteButtonView(
                position: deletePos,
                canvasScale: canvasScale,
                angle: Angle(degrees: photo.rotation ?? 0),
                action: onDelete
            )
        }
        .allowsHitTesting(true)
    }
    
    private func rotatedPoint(cx: Double, cy: Double, dx: Double, dy: Double, angle: Double) -> CGPoint {
        let x = cx + dx * cos(angle) - dy * sin(angle)
        let y = cy + dx * sin(angle) + dy * cos(angle)
        return CGPoint(x: x, y: y)
    }
}

// 1. view dot
struct ControlDot: View {
    let position: CGPoint
    let scale: CGFloat
    
    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 12, height: 12)
            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
            .position(position)
            .allowsHitTesting(false)
    }
}

// 2. Viền xanh
struct SelectionBorderView: View {
    let topLeft: CGPoint
    let topRight: CGPoint
    let bottomLeft: CGPoint
    let bottomRight: CGPoint
    let canvasScale: CGFloat
    
    var body: some View {
        Path { path in
            path.move(to: topLeft)
            path.addLine(to: topRight)
            path.addLine(to: bottomRight)
            path.addLine(to: bottomLeft)
            path.closeSubpath()
        }
        .stroke(Color.blue, lineWidth: 2 / canvasScale)
        .allowsHitTesting(false)
    }
}

// 3. Nút xoá ảnh
struct DeleteButtonView: View {
    let position: CGPoint
    let canvasScale: CGFloat
    let angle: Angle
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Circle()
                    .fill(Color(red: 1.0, green: 0.35, blue: 0.35))
                    .frame(width: 28, height: 28)
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 12, height: 2.5)
                    .cornerRadius(1)
            }
        }
        .rotationEffect(angle)
        .position(position)
    }
}
