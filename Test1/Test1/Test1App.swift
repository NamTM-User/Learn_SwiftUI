//
//  Test1App.swift
//  Test1
//
//  Created by Hai Nam on 11/5/26.
//

import SwiftUI

@main
struct Test1App: App {
    @State private var canvasModel = CanvasModel()
    
    var body: some Scene {
        WindowGroup {
            ProjectDetailMiddle()
                .environment(canvasModel)
                .preferredColorScheme(.light)
                .task {
                    do {
                        try await canvasModel.fetchData(21)
                    } catch {
                        print("Lỗi tải API lúc test: \(error)")
                    }
                }
        }
    }
}
