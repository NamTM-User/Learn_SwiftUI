//
//  PraticeSwiftUI2App.swift
//  PraticeSwiftUI2
//
//  Created by Hai Nam on 28/4/26.
//

import SwiftUI

@main
struct PraticeSwiftUI2App: App {
    @State private var modelData = ModelData()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(modelData)
        }
    }
}
