//
//  PremiumUpgradeView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//

import SwiftUI

struct PremiumUpgradeView: View {

    var body: some View {
        Button {
            print("Upgrade to Premium tapped")
        } label: {
            HStack(spacing: 16) {

                Image(systemName: "book.closed.fill")
                    .font(.title)
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Upgrade to Premium")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("""
                         Unlimited recipe books,
                         Dietary Preference Options,
                         and Removes Ads.
                         """)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange, Color.red]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                PremiumUpgradeBannerEffects()
            )
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 4)
    }
}


struct PremiumUpgradeView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumUpgradeView()
    }
}
