//
//  CanvasScrollView.swift
//  Test1
//

import SwiftUI

/*
 =========================== UIViewRepresentable========================
 
 - UIViewRepresentable: là 1 protocol giúp gói 1 View của UIKit thành 1 View của SwiftUI để dùng chung với code SwiftUI
 
 =======================================================================
 Trong quá trình app chạy, hàm updateUIView của bạn bị gọi đi gọi lại hàng chục lần.
 Nếu có những biến tạm thời không muốn bị mất đi sau mỗi lần SwiftUI re-render -> để vào Coordinator để lưu trữ
 (nó không bị huỷ đi mỗi lần SwiftUI re-render).
 
 */

struct CanvasScrollView: UIViewRepresentable {
    var size: CGSize
    var onSetup: (UIScrollView, UIView) -> Void
    var onZoom: (() -> Void)?
    var onScroll: (() -> Void)?
    let viewSwiftUI: AnyView

    // MARK: - Coordinator

    class Coordinator: NSObject, UIScrollViewDelegate {
        var contentView: UIView?
        var didLoad = false
        var onZoom: (() -> Void)?
        var onScroll: (() -> Void)?

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return contentView
        }

        // Căn giữa content khi zoom out
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            centerContent(scrollView)
            onZoom?()
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            onScroll?()
        }

        func centerContent(_ scrollView: UIScrollView) {
            guard let cv = contentView else { return }
            let boundsSize = scrollView.bounds.size
            let frame = cv.frame
            let offsetX = max((boundsSize.width  - frame.width)  * 0.5, 0)
            let offsetY = max((boundsSize.height - frame.height) * 0.5, 0)
            cv.center = CGPoint(
                x: frame.width  * 0.5 + offsetX,
                y: frame.height * 0.5 + offsetY
            )
        }

        // Chạy 1 lần sau khi layout hoàn tất
        func initOnce(_ scrollView: UIScrollView) {
            guard !didLoad else { return }
            didLoad = true
            centerContent(scrollView)
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    // A. Khởi tạo UIScrollView
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        context.coordinator.onZoom = onZoom
        context.coordinator.onScroll = onScroll
        scrollView.delegate = context.coordinator

        scrollView.showsVerticalScrollIndicator   = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom                    = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1)
        scrollView.clipsToBounds   = true
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 5.0

        let hosting = UIHostingController(rootView: viewSwiftUI)
        hosting.view.backgroundColor = .yellow
        hosting.view.frame.size      = CanvasSize
        hosting.view.clipsToBounds   = false

        scrollView.addSubview(hosting.view)
        scrollView.contentSize = CanvasSize
        context.coordinator.contentView = hosting.view

        onSetup(scrollView, hosting.view)
        return scrollView
    }

    // B. Update khi SwiftUI state đổi
    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        context.coordinator.onZoom = onZoom
        context.coordinator.onScroll = onScroll
        DispatchQueue.main.async {
            context.coordinator.initOnce(scrollView)
        }
    }
}
