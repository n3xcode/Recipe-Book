//
//  PremiumUpgradeBannerEffects.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//

import SwiftUI

struct PremiumUpgradeBannerEffects: View {
    @State private var moveGlint = false

    var body: some View {
        GeometryReader { geo in
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.0),
                    Color.white.opacity(0.6),
                    Color.white.opacity(0.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: geo.size.width * 2)
            .rotationEffect(.degrees(90))
            .offset(x: moveGlint ? geo.size.width * 1.2 : -geo.size.width * 1.2)
            .animation(
                Animation.linear(duration: 3)
                    .repeatForever(autoreverses: false),
                value: moveGlint
            )
            .onAppear {
                moveGlint = true
            }
        }
        .clipped()
        .allowsHitTesting(false)
    }
}


struct PremiumUpgradeBannerEffects_Previews: PreviewProvider {
    static var previews: some View {
        PremiumUpgradeBannerEffects()
    }
}
