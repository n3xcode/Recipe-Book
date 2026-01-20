//
//  RecipeTileView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

struct RecipeTileView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 120)
                .cornerRadius(12)
                .overlay(
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                )

            Text("Recipe Title")
                .font(.headline)
                .lineLimit(2)

            Text("Quick description or category")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct RecipeTileView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeTileView()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
