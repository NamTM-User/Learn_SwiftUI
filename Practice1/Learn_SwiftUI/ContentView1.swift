//
//  ContentView1.swift
//  Learn_SwiftUI
//
//  Created by Hai Nam on 28/4/26.
//

import SwiftUI

struct ContentView1: View {
    var body: some View {
        VStack {
            MapView().frame(height: 300)
            //
            Create_Image().offset(y: -110).padding(.bottom , -130)
            
            //
            VStack(alignment: .leading ,spacing: 20){
                Text("Turtle Rock").font(.title)
                
                HStack {
                    Text("Joshua Tree National Park")
                    Spacer()
                    Text("California")
                }
                .font(.subheadline)
                .foregroundStyle(.blue)
                
                Divider()
                Text("About Turtle Rock").font(.title2)
                Text("Descriptive text goes here.")
            }
            .padding()
            Spacer()
        }
    }
}

#Preview {
    ContentView1()
}
