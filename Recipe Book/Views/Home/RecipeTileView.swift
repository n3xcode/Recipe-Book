//
//  RecipeTileView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

struct RecipeTileView: View {

    let title: String
    let subtitle: String
    let imageName: String?   // later this becomes a URL

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 120)
                    .cornerRadius(12)

                if let imageName = imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(12)
                } else {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                }
            }

            Text(title)
                .font(.headline)
                .lineLimit(2)

            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
}


struct RecipeTileView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeTileView(
            title: "Creamy Garlic Pasta",
            subtitle: "Italian • 30 min",
            imageName: nil
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

