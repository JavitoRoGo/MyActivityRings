//
//  ActivityRing.swift
//  MyActivityRings
//
//  Created by Javier Rodríguez Gómez on 22/11/22.
//

import SwiftUI

struct ActivityRing: View {
    let progress: Double
    var ringRadius: Double = 180.0
    var thickness: CGFloat = 40.0
    var startColor = Color(red: 1.000, green: 0.596, blue: 0.588)
    var endColor = Color(red: 0.839, green: 0.153, blue: 0.157)
    
    private var ringTipShadowOffset: CGPoint {
        let ringTipPosition = tipPosition(progress: progress, radius: ringRadius)
        let shadowPosition = tipPosition(progress: progress + 0.0075, radius: ringRadius)
        return CGPoint(x: shadowPosition.x - ringTipPosition.x,
                       y: shadowPosition.y - ringTipPosition.y)
    }
    
    private func tipPosition(progress: Double, radius: Double) -> CGPoint {
        let progressAngle = Angle(degrees: (360.0 * progress) - 90.0)
        return CGPoint(x: radius * cos(progressAngle.radians),
                       y: radius * sin(progressAngle.radians))
    }
    
    var body: some View {
        let activityAngularGradient = AngularGradient(
            gradient: Gradient(colors: [startColor, endColor]),
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(360.0 * progress))
        
        ZStack {
            Circle()
                .stroke(startColor.opacity(0.15), lineWidth: thickness)
                .frame(width: CGFloat(ringRadius) * 2.0)
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(activityAngularGradient, style: StrokeStyle(lineWidth: thickness, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: CGFloat(ringRadius) * 2.0)
            ActivityRingTip(progress: progress, ringRadius: ringRadius)
                .fill(progress > 0.95 ? endColor : .clear)
                .frame(width: thickness, height: thickness)
                .shadow(color: progress > 0.95 ? .black.opacity(0.3) : .clear,
                        radius: 2.5, x: ringTipShadowOffset.x, y: ringTipShadowOffset.y)
        }
    }
}

struct ActivityRing_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRing(progress: 1.4)
    }
}
