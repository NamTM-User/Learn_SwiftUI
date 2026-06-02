//
//  PhotoGestureCoordinator.swift
//  Test1
//
//  Created by Hai Nam on 2/6/26.
//

import Foundation
import UIKit
import SwiftUI

// State gesture
struct GestureStateImage {
    let transform: PhotoTransform // trạng thái của img (drag/zoom) ngay lúc vừa chạm vào
    let focalPoint: CGPoint // Toạ độ giữa 2 ngón tay
    let isMultiTouch: Bool // property check đang chạm 1 ngón hay 2 ngón
}


// MARK: Gesture Coordinator ( Xử lý logic gesture )

class PhotoGestureCoordinator: NSObject, UIGestureRecognizerDelegate {
    let idx: Int
    weak var canvasModel: CanvasModel?
    
    weak var panGesture: UIPanGestureRecognizer?
    weak var pinchGesture: UIPinchGestureRecognizer?
    weak var rotateGesture: UIRotationGestureRecognizer?
    
    // 2. State local
    private var gestureState: GestureStateImage?
    private var activeTouchCount = 0
    
    // 3. init
    init(idx: Int, canvasModel: CanvasModel) {
        self.idx = idx
        self.canvasModel = canvasModel
    }
    
    // MARK: Logic gesture
    
    // 1. handle lúc ngón tay vừa chạm
    private func handleTouchStart(_ gesture: UIGestureRecognizer) {
        if activeTouchCount == 0 {
            guard let photos = canvasModel?.projectDetail?.photos , idx >= 0 , idx < photos.count else { return }
            
            let currentTransform = photos[idx].transform
            
            gestureState = GestureStateImage(transform: currentTransform, focalPoint: currentTransform.center, isMultiTouch: false)
            
            // block gesture canvas
            canvasModel?.scrollView?.isScrollEnabled = false
            canvasModel?.scrollView?.pinchGestureRecognizer?.isEnabled = false
            
        }
        activeTouchCount += 1
    }
    
    // 2. điểm giữa 2 ngón tay
    private func handleMultiTouch(_ gesture: UIGestureRecognizer) {
        guard let state = gestureState , !state.isMultiTouch else { return }
        guard let cv = canvasModel?.canvasContentView,
              let photos = canvasModel?.projectDetail?.photos , idx >= 0, idx < photos.count
        else { return }
        
        // toạ độ giao điểm giữa 2 ngón tay
        let currentTransform = photos[idx].transform
        let focalCanvas = gesture.location(in: cv)
        
        
        
        // reset translation before để tính translation hiện tại tránh bị cộng dồn
        panGesture?.setTranslation(CGPoint(x: 0, y: 0), in: cv)
        pinchGesture?.scale = 1.0
        rotateGesture?.rotation = 0.0
        // update
        gestureState = GestureStateImage(transform: currentTransform, focalPoint: focalCanvas, isMultiTouch: true)
    }
    
    // 3. update
    private func updateImagePosition(_ gesture: UIGestureRecognizer) {
        guard let state = gestureState , let cv = canvasModel?.canvasContentView else { return }
        
        let panTranslation: CGPoint = {
            guard let r = panGesture else { return .zero }
            let t = r.translation(in: cv)
            return CGPoint(x: t.x, y: t.y)
        }()
        
        let scaleDelta: CGFloat = pinchGesture?.scale ?? 1.0
        let angleDelta: Double = Double(rotateGesture?.rotation ?? 0.0)
        
        var newCenter = state.transform.center
        
        // check 2 finger rotate
        if state.isMultiTouch {
            let focalX = state.focalPoint.x
            let focalY = state.focalPoint.y
            
            var transform = CGAffineTransform(translationX: focalX, y: focalY)
            transform = transform.scaledBy(x: scaleDelta, y: scaleDelta)
            transform = transform.rotated(by: CGFloat(angleDelta))
            transform = transform.translatedBy(x: -focalX, y: -focalY)
            
            // Áp dụng lên center
            newCenter = state.transform.center.applying(transform)
            
        }
        
        // + drag
        newCenter.x += panTranslation.x
        newCenter.y += panTranslation.y
        
        let newTransform = PhotoTransform(
            center: newCenter,
            scale: state.transform.scale * scaleDelta,
            rotation: state.transform.rotation + angleDelta,
            baseSize: state.transform.baseSize
        )
        
        // update canvasmodel
        canvasModel?.updatePhotoTransform(index: idx, transform: newTransform)
    }
    
    // 4. handle finger drop
    private func handleTouchEnd(_ gesture: UIGestureRecognizer) {
        activeTouchCount = max(0 , activeTouchCount - 1)
        
        if activeTouchCount == 0 {
            // unblock gesture canvas
            canvasModel?.scrollView?.isScrollEnabled = true
            canvasModel?.scrollView?.pinchGestureRecognizer?.isEnabled = true
            // delete state
            gestureState = nil
            
        }
        else {
            guard let photos = canvasModel?.projectDetail?.photos , idx >= 0 , idx < photos.count ,
                  let cv = canvasModel?.canvasContentView
            else { return }
            
            let currentStateImage = photos[idx].transform
            // reset
            panGesture?.setTranslation(.zero, in: cv)
            pinchGesture?.scale = 1.0
            rotateGesture?.rotation = 0.0
            
            // check gesture pinch + rotate active?
            let checkTouch = (pinchGesture?.isActive == true || rotateGesture?.isActive == true)
            // update
            gestureState = GestureStateImage(
                transform: currentStateImage,
                focalPoint: currentStateImage.center,
                isMultiTouch: checkTouch
            )
            
            // reset state class
            if gesture === pinchGesture {
                pinchGesture?.scale = 1.0
            }
            if gesture === rotateGesture {
                rotateGesture?.rotation = 0.0
            }
        }
    }
    
    // combine gesture
    func gestureRecognizer(
        _ gesture : UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return otherGestureRecognizer.delegate === self
    }
    
    
    // MARK: GESTURE Actions
    
    // 1. Drag
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began { // finger start
            handleTouchStart(gesture)
        }
        else if gesture.state == .changed { // finger move
            updateImagePosition(gesture)
        }
        else if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
            handleTouchEnd(gesture)
        }
    }
    
    // 2. Zoom
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .began {
            handleTouchStart(gesture) // ngón tay vừa chạm tạo checkpoint active
            handleMultiTouch(gesture)
        }
        else if gesture.state == .changed {
            updateImagePosition(gesture)
        }
        else if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed  {
            handleTouchEnd(gesture)
        }
    }
    
    // 3. Rotate
    @objc func handleRotate(_ gesture: UIRotationGestureRecognizer) {
        if gesture.state == .began {
            handleTouchStart(gesture)
            
            handleMultiTouch(gesture)
        }
        else if gesture.state == .changed {
            updateImagePosition(gesture)
        }
        else if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
            handleTouchEnd(gesture)
        }
    }
}



private extension UIGestureRecognizer {
    var isActive: Bool {
        return state == .began || state == .changed
    }
}
