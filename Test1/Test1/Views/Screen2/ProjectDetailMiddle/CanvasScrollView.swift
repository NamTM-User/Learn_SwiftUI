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
    // Hàm callback để truyền scrollView ngược ra ngoài cho ProjectDetailMiddle
    var onSetup: (UIScrollView, UIView) -> Void
    
    // property view SwiftUI
    let viewSwiftUI: AnyView
    
    // class Coordinator ( listen event UIScrollView ), Coordinator để lắng nghe share state data giữa swiftui và uikit
    class Coordinator: NSObject, UIScrollViewDelegate {
        var contentView: UIView?
        
        // 1. method thông báo UIScrollView view nào sẽ zoom/scale
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return contentView
        }
        
        // 2. handle changed zoom , căn giữa khi zoom out
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            guard let cv = contentView else { return }
            
            let boundsSize = scrollView.bounds.size
            let frame = cv.frame
            
            let offsetX = max((boundsSize.width - frame.width) * 0.5, 0)
            let offsetY = max((boundsSize.height - frame.height) * 0.5, 0)
            
            cv.center = CGPoint(
                x: frame.width * 0.5 + offsetX,
                y: frame.height * 0.5 + offsetY
            )
        }
    }
    
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    // A. init UIView
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator // gán object nhận cho ScrollView
        
        // 1. thanh scroll dọc , ngang
        scrollView.showsVerticalScrollIndicator = false ; scrollView.showsHorizontalScrollIndicator = false
        // 2. effect đàn hồi
        scrollView.bouncesZoom = true
        // 3. chặn hành vi lấn UI mặc định của UI có sẵn ScrollView
        scrollView.contentInsetAdjustmentBehavior = .never
        // 4. background
        scrollView.backgroundColor = UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1) // alpha la` opacity
        // 5. clipped()
        scrollView.clipsToBounds = true
        // 6. giới hạn zoom
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 5.0
        
        let hosting = UIHostingController(rootView: viewSwiftUI)
        hosting.view.backgroundColor = .yellow 
        
        hosting.view.frame.size = CanvasSize
        
        // subview
        scrollView.addSubview(hosting.view)
        scrollView.contentSize = CanvasSize
        
        // Gán coordinator để listen event zoom
        context.coordinator.contentView = hosting.view
        
        // Gọi callback báo ra ngoài
        onSetup(scrollView, hosting.view)
        
        return scrollView
        
    }
    // B.update khi state SwiftUI đổi
    func updateUIView(_ scrollView: UIScrollView , context: Context) {
        // ........
    }
    
}
