import SwiftUI

@available(iOS 18.0, *)
struct TestPan: UIGestureRecognizerRepresentable {
    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        UIPanGestureRecognizer()
    }
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {}
}

@available(iOS 18.0, *)
struct TestView: View {
    var body: some View {
        Text("Hello")
            .gesture(TestPan())
    }
}
