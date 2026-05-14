//
//  ContentView.swift
//  Test1
//
//  Created by Hai Nam on 11/5/26.
//

import SwiftUI

struct ContentView: View {
    let api = APIService()
    
    var body: some View {
        Text("ABC")
            .task {
                do {
                    print("1. Start call apii")
                     
                    let data = try await api.getAPI()
                    print("2. API Reponse")
                    print(data.projects)
                } catch {
                    print(error)
                }
            }
    }
}

#Preview {
    ContentView()
}
