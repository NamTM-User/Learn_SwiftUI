//
//  FrameBot.swift
//  PraticeSwiftUI
//
//  Created by Hai Nam on 6/5/26.
//

import SwiftUI
import PhotosUI

struct FrameBot: View {
    @State private var selectedItemA: PhotosPickerItem? = nil
    @State private var selectedItemB: PhotosPickerItem? = nil
    
    
    var body: some View {
        HStack(spacing: 10){
            // A
            PhotosPicker(
                selection: $selectedItemA,
                matching: .images,
                photoLibrary: .shared() // default
            ) {
                Text("Pick Photo \n A")
                    .font(.system(size: 16 , weight: .bold))
                    .foregroundStyle(Color(hex: "F7ECFF"))
                    .frame(width: 120, height: 90)
                    .background(Color(hex: "8563FF"))
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    
            }
            
            
            // B
            PhotosPicker(
                selection: $selectedItemB,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Pick Photo \n B")
                    .font(.system(size: 16 , weight: .bold))
                    .foregroundStyle(Color(hex: "F7ECFF"))
                    .frame(width: 120, height: 90)
                    .background(Color(hex: "8563FF"))
                    .clipShape(RoundedRectangle(cornerRadius: 28))
            }
        }
    }
}

#Preview {
    FrameBot()
}
