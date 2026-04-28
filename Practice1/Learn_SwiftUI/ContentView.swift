//
//  ContentView.swift
//  Learn_SwiftUI
//
//  Created by Hai Nam on 23/4/26.
//

// =========================================================================================
// --------> Ý nghĩa ContentView , struct ContentView: View , định nghĩa lại giao diện cho màn hình . Mọi thứ viết trong biến (body) sẽ xuất hiện trên màn hình điện thoại

// #Preview { ... } giúp Xcode hiển thị 1 màn hình Preview là Canvas mà không cần phải chạy chương trình giả lập (Simulator)

// File Assets ở cùng folder : là nơi sẽ kéo thả hình ảnh , icon ứng dụng , hoặc định nghĩa các bảng màu tuỳ chỉnh đê sử dụng trong code.

// .padding trong SwiftUI là một modifier dùng để tạo khoảng cách (space) giữa nội dung của View và các phần xung quanh nó.

import SwiftUI

struct ContentView: View {
    var text:AttributedString {
        var content = AttributedString("Hello World")
        
        if let range = content.range(of: "Hello") {
            content[range].foregroundColor = .red
        }
        
        if let range = content.range(of: "World"){
            content[range].foregroundColor = .blue
        }
        return content
    }
    
    var body: some View {
        VStack{
            // test font basic
            Text("Check Text 1").font(.largeTitle)
            // test font custom size không theo preset
            Text("Check Text 2").font(.system(size: 40, weight: .black , design: .rounded))
            // test font preset + custom design , weight
            Text("Check Text 3").font(.system(.largeTitle , design: .serif , weight: .bold))
            
            // check font custom1
            Text("Check Text 4").font(.custom("Helvetica Neue", size: 50))
            // check font custom2
            Text("Check Text 5").font(.custom("Times New Roman", size: 60, relativeTo: .body))
            // test spacer()
            Spacer()
            // frame (tạo khung) + background
            Text("Check Text 6").font(.system(size: 30)).frame(width: 200 , height: 300).background(Color.blue)
            
            // AttributedString
            Text(text).padding(30)
        }
        
    }
}

#Preview {
    ContentView()
}   
