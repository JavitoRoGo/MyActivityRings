//
//  MyActivityRingsApp.swift
//  MyActivityRings
//
//  Created by Javier Rodríguez Gómez on 21/11/22.
//

import SwiftUI

@main
struct MyActivityRingsApp: App {
    @StateObject var model = MyViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
