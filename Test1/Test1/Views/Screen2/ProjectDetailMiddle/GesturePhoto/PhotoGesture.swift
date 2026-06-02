import UIKit
import SwiftUI

// MARK: - Custom View bắt Touch
class TouchCatcherView: UIView {
    weak var canvasModel: CanvasModel?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // KHOÁ CỨNG CANVAS NGAY KHI VỪA CHẠM NGÓN TAY!
        canvasModel?.scrollView?.isScrollEnabled = false
        canvasModel?.scrollView?.pinchGestureRecognizer?.isEnabled = false
    }
    
    // Bug 1 Fix: Canvas Deadlock
    // touchesBegan khoá canvas nhưng nếu user chỉ tap rồi thả (không trigger UIGestureRecognizer nào)
    // thì canvas bị khoá vĩnh viễn. Cần mở khoá lại ở đây nếu không có gesture nào đang active.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let anyGestureActive = gestureRecognizers?.contains(where: {
            $0.state == .began || $0.state == .changed
        }) ?? false
        if !anyGestureActive {
            canvasModel?.scrollView?.isScrollEnabled = true
            canvasModel?.scrollView?.pinchGestureRecognizer?.isEnabled = true
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        // Touch bị cancel (call incoming, system interrupt...) → unlock canvas ngay
        canvasModel?.scrollView?.isScrollEnabled = true
        canvasModel?.scrollView?.pinchGestureRecognizer?.isEnabled = true
    }
}

// MARK: Gán UIView cho Gesture

struct PhotoGesture: UIViewRepresentable {
    let idx: Int
    let isSelected: Bool
    weak var canvasModel: CanvasModel?
    
    func makeCoordinator() -> PhotoGestureCoordinator {
        PhotoGestureCoordinator(idx: idx, canvasModel: canvasModel!)
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = TouchCatcherView()
        view.canvasModel = canvasModel
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
