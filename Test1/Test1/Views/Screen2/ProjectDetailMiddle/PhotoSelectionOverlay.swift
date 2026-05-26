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
    let canvasOffset: CGSize
    let screenCenter: CGPoint
    var onDelete: () -> Void
    
    var body: some View {
        let hw = photo.frame.width / 2
        let hh = photo.frame.height / 2
        
        let topLeft     = getScreenPoint(dx: -hw, dy: -hh)
        let topRight    = getScreenPoint(dx:  hw, dy: -hh)
        let bottomLeft  = getScreenPoint(dx: -hw, dy:  hh)
        let bottomRight = getScreenPoint(dx:  hw, dy:  hh)
        
        let deletePos = getScreenPoint(dx: 0, dy: -hh - (35 / canvasScale))
        
        ZStack {
            // Viền xanh
            SelectionBorderView(
                topLeft: topLeft,
                topRight: topRight,
                bottomLeft: bottomLeft,
                bottomRight: bottomRight
            )
            
            // 4 dot
            ControlDot(position: topLeft)
            ControlDot(position: topRight)
            ControlDot(position: bottomLeft)
            ControlDot(position: bottomRight)
            
            // Nút xoá
            DeleteButtonView(
                position: deletePos,
                angle: Angle(degrees: photo.rotation ?? 0),
                action: onDelete
            )
        }
        .allowsHitTesting(true)
    }
    
    private func getScreenPoint(dx: Double, dy: Double) -> CGPoint {
        // 1. Toạ độ theo góc xoay
        let angle = Angle(degrees: photo.rotation ?? 0).radians
        let cx = photo.frame.x
        let cy = photo.frame.y
        
        let canvasX = cx + dx * cos(angle) - dy * sin(angle)
        let canvasY = cy + dx * sin(angle) + dy * cos(angle)
        
        // 2. Map ra hệ toạ độ màn hình 
        let screenX = screenCenter.x + (canvasX - screenCenter.x) * canvasScale + canvasOffset.width
        let screenY = screenCenter.y + (canvasY - screenCenter.y) * canvasScale + canvasOffset.height
        
        return CGPoint(x: screenX, y: screenY)
    }
}

// 1. view dot
struct ControlDot: View {
    let position: CGPoint
    
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
    
    var body: some View {
        Path { path in
            path.move(to: topLeft)
            path.addLine(to: topRight)
            path.addLine(to: bottomRight)
            path.addLine(to: bottomLeft)
            path.closeSubpath()
        }
        .stroke(Color.blue, lineWidth: 2)
        .allowsHitTesting(false)
    }
}

// 3. Nút xoá ảnh 
struct DeleteButtonView: View {
    let position: CGPoint
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
