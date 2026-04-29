//
//  FavoriteButton.swift
//  PraticeSwiftUI2
//
//  Created by Hai Nam on 29/4/26.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool

    var body: some View {
        Button{
            isSet.toggle()
        }label: {
            Label("Toggle Favorite", systemImage: isSet ? "star.fill" : "star").labelStyle(.iconOnly).foregroundStyle(isSet ? .yellow : .gray)
        }
    }
}

#Preview {
    // phải truyền dạng $...
    // Trong #Preview, bạn không có @State sẵn
    // → nên phải tự tạo Binding “fake” (.constant(true))
    // 👉 chỉ dùng cho preview / test UI
    FavoriteButton(isSet: .constant(true))
}
