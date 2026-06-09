//
//  OverlayUIView.swift
//  Test1
//
//  Created by Hai Nam on 8/6/26.
//

import Foundation
import UIKit
import SwiftUI

class OverlayUIView: UIView {
    
    // ĐƯA MỌI THỨ VÀO 1 CÁI CONTAINER ĐỂ NÓ XOAY/CHẠY MÀ KHÔNG LÀM HỎNG VIEW GỐC
    let containerView = UIView()
    
    let borderLayer = CAShapeLayer()
    var dotViews: [UIView] = []
    let deleteBtn = UIButton(type: .system)
    
    var onDelete: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // setup UI
    private func setupUI() {
        // Gắn containerView vào OverlayUIView
        addSubview(containerView)
        
        // A. MARK: - BORDER
        borderLayer.strokeColor = UIColor.blue.cgColor
        // fill màu bên trong
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 2.0
        
        // Gắn border vào container
        containerView.layer.addSublayer(borderLayer)
        
        // B. MARK: - DotViews
        for _ in 0..<4 {
            let dot = UIView()
            dot.backgroundColor = .white
            dot.layer.borderColor = UIColor.white.cgColor
            dot.layer.borderWidth = 2
            // shadow, opacity
            dot.layer.shadowColor = UIColor.black.cgColor
            dot.layer.shadowOpacity = 0.3
            dot.layer.shadowOffset = .zero
            dot.layer.shadowRadius = 2
            
            // block touch
            dot.isUserInteractionEnabled = false
            
            // Gắn vào container
            containerView.addSubview(dot)
            dotViews.append(dot)
        }
        
        // C. MARK: - Deletebtn
        deleteBtn.backgroundColor = UIColor(red: 1.0, green: 0.27, blue: 0.27, alpha: 1.0)
        deleteBtn.layer.cornerRadius = 16
        let minusLine = UIView(frame: CGRect(x: 9, y: 14.5, width: 14, height: 3))
        minusLine.backgroundColor = .white
        minusLine.layer.cornerRadius = 1.5
        minusLine.isUserInteractionEnabled = false
        deleteBtn.addSubview(minusLine)
        
        deleteBtn.addTarget(self, action: #selector(tapDelete), for: .touchUpInside)
        // Gắn vào container
        containerView.addSubview(deleteBtn)
    }
    
    @objc private func tapDelete() {
        onDelete?()
    }
    
    // MARK: - Update Position Overlay
    func updatePosition(model: CanvasModel) {
        guard let idx = model.selectedPhotoIndex,
              let detail = model.projectDetail,
              idx < detail.photos.count,
              let cv = model.canvasContentView // canvas content
        else {
            self.isHidden = true // ẩn view
            return
        }
        
        self.isHidden = false // hiện view
        let photo = detail.photos[idx] // image current
        
        // convert center image current -> overlay
        // explain: Lấy toạ độ center của cv ( canvas content ) đổi sang view ProjectDetailMiddle
        let centerOverlaySeletion = cv.convert(photo.transform.center, to: self)
        
        // lấy size zoom canvas
        let zoomScale = model.scrollView?.zoomScale ?? 1.0
        // size image scale
        let sizeImageScale = photo.transform.scale * zoomScale
        
        let w = photo.transform.baseSize.width * sizeImageScale // width
        let h = photo.transform.baseSize.height * sizeImageScale // height
        
        // RESET TRANSFORM CỦA CONTAINER TRƯỚC KHI VẼ
        containerView.transform = .identity 
        
        // MARK: - Draw Rectangle
        let rect = CGRect(x: -w/2, y: -h/2, width: w, height: h)
        borderLayer.path = UIBezierPath(rect: rect).cgPath // draw
        
        // lấy 4 góc của rectangle
        let corners = [
            CGPoint(x: -w/2, y: -h/2), // trái trên
            CGPoint(x: w/2, y: -h/2),  // phải trên
            CGPoint(x: -w/2, y: h/2),  // trái dưới
            CGPoint(x: w/2, y: h/2)    // phải dưới
        ]
        
        for (i, dot) in dotViews.enumerated() {
            dot.bounds = CGRect(x: 0, y: 0, width: 14, height: 14)
            dot.layer.cornerRadius = 7
            dot.center = corners[i]
        }
        
        deleteBtn.bounds = CGRect(x: 0, y: 0, width: 32, height: 32)
        deleteBtn.center = CGPoint(x: 0, y: -h/2 - 30)
        
        containerView.center = centerOverlaySeletion
        containerView.transform = CGAffineTransform(rotationAngle: photo.rotation)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Chỉ bắt touch nếu ngón tay touch trúng chính xác vào nút Delete
        // Mọi vị trí khác đều trả về nil để xuyên qua
        
        let pointInButton = self.convert(point, to: deleteBtn)
        if deleteBtn.bounds.contains(pointInButton) {
            return deleteBtn
        }
        
        return nil
    }
}

// MARK: Wrapper SwiftUI
struct OverlayPhotoSeclection: UIViewRepresentable {
    let canvasModel: CanvasModel
    
    func makeUIView(context: Context) -> OverlayUIView {
        let view = OverlayUIView()
        view.onDelete = {
            canvasModel.deletePhoto()
        }
        canvasModel.overlayView = view
        return view
    }
    
    func updateUIView(_ uiView: OverlayUIView, context: Context) {
        uiView.updatePosition(model: canvasModel)
    }
}
