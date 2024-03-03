//
//  ContentView.swift
//  MyActivityRings
//
//  Created by Javier Rodríguez Gómez on 21/11/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("", systemImage: "clock")
                }
            
            ChartView()
                .tabItem {
                    Label("", systemImage: "calendar")
                }
            TrainingView()
                .tabItem {
                    Label("", systemImage: "figure.walk")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MyViewModel())
    }
}
