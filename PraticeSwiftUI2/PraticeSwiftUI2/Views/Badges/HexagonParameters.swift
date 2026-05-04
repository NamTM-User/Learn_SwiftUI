//
//  HexagonParameters.swift
//  PraticeSwiftUI2
//
//  Created by Hai Nam on 4/5/26.
//

import Foundation
// CGPoint là 1 struct biểu diễn 1 điểm trong hệ toạ độ 2D (x,y) , CGPoint = tọa độ vị trí của một view trên màn hình
// CGFloat = kiểu số chuẩn cho UI trong Swift => Dùng khi làm việc với: CGPoint , CGRect , layout, animation ,Tránh lỗi ép kiểu khi dùng API của Apple

struct HexagonParameters {
    struct Segment {
        let line: CGPoint
        let curve: CGPoint // đường cong
        let control: CGPoint
    }
    
    //value điều chỉnh hình dạng của hình lục giác
    static let adjustment: CGFloat = 0.085
    
    // 1 mảng giữ các segment
    static let segments = [
        Segment(
            line:    CGPoint(x: 0.60, y: 0.05),
            curve:   CGPoint(x: 0.40, y: 0.05),
            control: CGPoint(x: 0.50, y: 0.00)
        ),
        Segment(
            line:    CGPoint(x: 0.05, y: 0.20 + adjustment),
            curve:   CGPoint(x: 0.00, y: 0.30 + adjustment),
            control: CGPoint(x: 0.00, y: 0.25 + adjustment)
        ),
        Segment(
            line:    CGPoint(x: 0.00, y: 0.70 - adjustment),
            curve:   CGPoint(x: 0.05, y: 0.80 - adjustment),
            control: CGPoint(x: 0.00, y: 0.75 - adjustment)
        ),
        Segment(
            line:    CGPoint(x: 0.40, y: 0.95),
            curve:   CGPoint(x: 0.60, y: 0.95),
            control: CGPoint(x: 0.50, y: 1.00)
        ),
        Segment(
            line:    CGPoint(x: 0.95, y: 0.80 - adjustment),
            curve:   CGPoint(x: 1.00, y: 0.70 - adjustment),
            control: CGPoint(x: 1.00, y: 0.75 - adjustment)
        ),
        Segment(
            line:    CGPoint(x: 1.00, y: 0.30 + adjustment),
            curve:   CGPoint(x: 0.95, y: 0.20 + adjustment),
            control: CGPoint(x: 1.00, y: 0.25 + adjustment)
        )
    ]
}
