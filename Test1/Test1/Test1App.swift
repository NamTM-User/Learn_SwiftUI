//
//  Test1App.swift
//  Test1
//
//  Created by Hai Nam on 11/5/26.
//

import SwiftUI

@main
struct Test1App: App {
    @State private var store = ProjectModel()
    
    var body: some Scene {
        WindowGroup {
            ProjectListView()
                .environment(store)
                .preferredColorScheme(.light)
        }
    }
}
