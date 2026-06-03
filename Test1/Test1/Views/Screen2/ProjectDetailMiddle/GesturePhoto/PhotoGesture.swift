import UIKit
import SwiftUI

// MARK: Gán UIView cho Gesture

struct PhotoGesture: UIViewRepresentable {
    let idx: Int
    let isSelected: Bool
    weak var canvasModel: CanvasModel?
    
    func makeCoordinator() -> PhotoGestureCoordinator {
        PhotoGestureCoordinator(idx: idx, canvasModel: canvasModel!)
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        //isUserInteractionEnabled là thuộc tính bật/tắt khả năng nhận tương tác của user trên UIView
        view.isUserInteractionEnabled = isSelected
        
        // init gesture
        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(PhotoGestureCoordinator.handlePan))
        let pinch = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(PhotoGestureCoordinator.handlePinch))
        let rotate = UIRotationGestureRecognizer(target: context.coordinator, action: #selector(PhotoGestureCoordinator.handleRotate))
        
        // gán gesture
        for gesture in [pan , pinch , rotate] {
            gesture.delegate = context.coordinator
            view.addGestureRecognizer(gesture)
        }
        
        context.coordinator.panGesture = pan
        context.coordinator.pinchGesture = pinch
        context.coordinator.rotateGesture = rotate
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.isUserInteractionEnabled = isSelected
    }

    
}
