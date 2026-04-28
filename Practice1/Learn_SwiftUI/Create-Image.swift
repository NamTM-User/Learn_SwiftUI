//
//  Create-Image.swift
//  Learn_SwiftUI
//
//  Created by Hai Nam on 24/4/26.
//

// resizeable() nó không resize ngay lập tức , nó mở quyền cho phép ảnh được phép kéo co giãn , Image() bình thường sẽ không co giãn được , thêm .resizeable() sẽ cho phép ảnh được kéo co giãn

// .shadow(radius: _) : đổ bóng cho toàn bộ view

import SwiftUI

struct Create_Image: View {
    var body: some View {
        Image("gratisography-augmented-reality-800x525").resizable().frame(width: 200, height: 300).clipped()
            .clipShape(Circle()).overlay(Circle().stroke(.red , lineWidth: 5))
    }
}

#Preview {
    Create_Image()
}
