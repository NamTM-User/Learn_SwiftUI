import SwiftUI

class Coordinator: NSObject, UIGestureRecognizerDelegate {
    static let shared = Coordinator()
    func gestureRecognizer(_ g: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool {
        // Chỉ cho phép đa nhiệm nếu 2 cử chỉ đang tác động lên cùng 1 view
        true
    }
}

// 1. gesture di chuyen (pan / drag)
struct PhotoPanGesture: UIGestureRecognizerRepresentable {
    let canvasScale: CGFloat
    let onDelta: (CGSize) -> Void
    
    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator.shared
    }
    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        let pan = UIPanGestureRecognizer()
        // Gán delegate của nó chính là coordinator để cho phép nhận diện nhiều cử chỉ cùng lúc
        pan.delegate = context.coordinator
        return pan
    }
    
    // Hàm xử lý mỗi khi có tương tác ngón tay làm thay đổi trạng thái của cử chỉ
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        // Kiểm tra nếu ngón tay đang di chuyển (trạng thái .changed) thì mới xử lý
        if recognizer.state == .changed {
            // Lấy translation dựa trên view cha (Canvas)
            let t = recognizer.translation(in: recognizer.view?.superview)
            // Khử tỉ lệ phóng to của Canvas
            let delta = CGSize(width: t.x / canvasScale, height: t.y / canvasScale)
            onDelta(delta)
            // reset
            recognizer.setTranslation(.zero, in: recognizer.view?.superview)
        }
    }
    
}

// 2. zoom
struct PhotoPinchGesture: UIGestureRecognizerRepresentable {
    let onDelta: (CGFloat, CGPoint) -> Void
    
    // Hàm tạo ra Coordinator
    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator.shared
    }
    
    func makeUIGestureRecognizer(context: Context) -> UIPinchGestureRecognizer {
        let pinch = UIPinchGestureRecognizer()
        pinch.delegate = context.coordinator
        return pinch
    }
    
    // Hàm xử lý khi người dùng zoom 2 ngón tay
    func handleUIGestureRecognizerAction(_ recognizer: UIPinchGestureRecognizer, context: Context) {
        if recognizer.state == .changed {
            let focalPoint = recognizer.location(in: recognizer.view?.superview)
            onDelta(recognizer.scale, focalPoint)
            recognizer.scale = 1.0
        }
    }
    
}

// 3. rotate
struct PhotoRotateGesture: UIGestureRecognizerRepresentable {
    let onDelta: (CGFloat, CGPoint) -> Void
    
    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator.shared
    }
    
    func makeUIGestureRecognizer(context: Context) -> UIRotationGestureRecognizer {
        let rotate = UIRotationGestureRecognizer()
        // Gán delegate để hỗ trợ đa nhiệm
        rotate.delegate = context.coordinator
        return rotate
    }
    
    // Hàm xử lý góc xoay khi người dùng vặn 2 ngón tay
    func handleUIGestureRecognizerAction(_ recognizer: UIRotationGestureRecognizer, context: Context) {
        if recognizer.state == .changed {
            let focalPoint = recognizer.location(in: recognizer.view?.superview)
            onDelta(recognizer.rotation, focalPoint)
            // reset
            recognizer.rotation = 0.0
        }
    }
    
}


// combine
struct PhotoGesturesModifier: ViewModifier {
    let isSelected: Bool
    let canvasScale: CGFloat
    let onPan: (CGSize) -> Void
    let onPinch: (CGFloat, CGPoint) -> Void
    let onRotate: (CGFloat, CGPoint) -> Void
    
    func body(content: Content) -> some View {
        if isSelected {
            // Do một compiler bug của Swift trên iOS 18, ko thể gộp 3 UIGestureRecognizerRepresentable
            // lại bằng hàm `.simultaneously(with:)`. Bắt buộc phải gắn lần lượt 3 cái `.gesture(...)`
            // lên cùng một view. Delegate Coordinator bên trên sẽ tự động cho phép chúng chạy //
            content
                .gesture(PhotoPanGesture(canvasScale: canvasScale, onDelta: onPan))
                .gesture(PhotoPinchGesture(onDelta: onPinch))
                .gesture(PhotoRotateGesture(onDelta: onRotate))
        } else {
            content
        }
    }
}

extension View {
    func photoGestures(
        isSelected: Bool,
        canvasScale: CGFloat,
        onPan: @escaping (CGSize) -> Void,
        onPinch: @escaping (CGFloat, CGPoint) -> Void,
        onRotate: @escaping (CGFloat, CGPoint) -> Void
    ) -> some View {
        self.modifier(PhotoGesturesModifier(
            isSelected: isSelected,
            canvasScale: canvasScale,
            onPan: onPan,
            onPinch: onPinch,
            onRotate: onRotate
        ))
    }
}


// -------- Gestures Canvas (Background)
struct CanvasPanGesture: UIGestureRecognizerRepresentable {
    let onDelta: (CGSize) -> Void
    
    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator.shared
    }
    
    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        let pan = UIPanGestureRecognizer()
        pan.delegate = context.coordinator
        return pan
    }
    
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        if recognizer.state == .changed {
            let t = recognizer.translation(in: recognizer.view)
            onDelta(CGSize(width: t.x, height: t.y)) 
            recognizer.setTranslation(.zero, in: recognizer.view)
        }
    }
}

struct CanvasPinchGesture: UIGestureRecognizerRepresentable {
    let onPinch: (CGFloat, CGPoint) -> Void
    
    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator.shared
    }
    
    func makeUIGestureRecognizer(context: Context) -> UIPinchGestureRecognizer {
        let pinch = UIPinchGestureRecognizer()
        pinch.delegate = context.coordinator
        return pinch
    }
    
    func handleUIGestureRecognizerAction(_ recognizer: UIPinchGestureRecognizer, context: Context) {
        if recognizer.state == .changed {
            let scaleDelta = recognizer.scale
            let focalPoint = recognizer.location(in: recognizer.view)

            onPinch(scaleDelta, focalPoint)
            recognizer.scale = 1.0
        }
    }
}
