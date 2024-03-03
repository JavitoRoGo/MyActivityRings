//
//  RingView.swift
//  MyActivityRings
//
//  Created by Javier Rodríguez Gómez on 22/11/22.
//

import SwiftUI

struct RingView: View {
    let data: MyModel
    
    @State private var showingRing = true
    
    var body: some View {
        ZStack {
            ActivityRing(progress: showingRing ? Double(data.movement) / 300.0 : 0,
                         ringRadius: 160,
                         thickness: 36)
            ActivityRing(progress: showingRing ? Double(data.exercise) / 30.0 : 0,
                         ringRadius: 120,
                         thickness: 36,
                         startColor: Color(red: 146/255, green: 225/255, blue: 166/255),
                         endColor: .green)
            ActivityRing(progress: showingRing ? Double(data.standUp) / 12.0 : 0,
                         ringRadius: 80,
                         thickness: 36,
                         startColor: Color(red: 118/255, green: 184/255, blue: 255/255),
                         endColor: .blue)
        }
        .frame(height: 350)
//        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                withAnimation(.interactiveSpring(response: 1.5, dampingFraction: 1.5, blendDuration: 1).delay(0.1)) {
//                    showingRing = true
//                }
//            }
//        }
    }
}

struct RingView_Previews: PreviewProvider {
    static var previews: some View {
        RingView(data: MyModel.example[0])
    }
}
