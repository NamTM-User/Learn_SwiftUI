//
//  ProjectDetailBottom.swift
//  Test1
//
//  Created by Hai Nam on 15/5/26.
//

import SwiftUI
import PhotosUI

struct ProjectDetailBottom: View {
    var onAddPhoto: (Data) -> Void
    
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $selectedItem,
                         matching: .images) {
                Text("Add Photo")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 40)
            //change
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let imgData = try await newItem?.loadTransferable(type: Data.self) {
                        onAddPhoto(imgData)
                        selectedItem = nil
                    }
                }
            }
            
            
        }
        .frame(height: 150)
        .background(Color(white: 0.98))
    }
}
