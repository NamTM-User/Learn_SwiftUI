//
//  ContentView.swift
//  test123
//
//  Created by Hai Nam on 12/5/26.
//

import SwiftUI

struct ContentView: View {
    @State var date = Date()
    var body: some View {
        VStack {
            
            TimelineView(.animation) { c in
                Text("\(c.date.timeIntervalSince(date))")
            }
            
            Button {
                Task.detached {
                    try await AITask.doSomethiing()
                }
            } label: {
                Image(uiImage: .checkmark)
                    .foregroundStyle(Color.white)
                    .frame(width: 44, height: 44)
                    .glassEffect(.regular.tint(.black))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            Task {
                try AITask.load()
                print("Done")
            }
        }
    }
}

#Preview {
    ContentView()
}
