//
//  Learn_SwiftUIApp.swift
//  Learn_SwiftUI
//
//  Created by Hai Nam on 23/4/26.
//

// file Learn_SwiftUIApp.swift là điểm khởi đầu của ứng dụng khi create project . Nó chứa struct có đánh dấu @main . Khi run project hệ thống sẽ tìm đến file này đầu tiên để chạy ứng dụng
// WindowGroup là nơi khai báo UI gốc của app , Nó chứa ContentView , quản lý vòng đời của của Window ----> Không có WindowGroup → không có chỗ để hiển thị UI

import SwiftUI

@main
struct Learn_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView() // Chỗ { ... } này phải trả về 1 View duy nhất
        }
    }
}
