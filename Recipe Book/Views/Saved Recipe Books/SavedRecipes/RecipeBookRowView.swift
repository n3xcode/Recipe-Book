//
//  RecipeBookRowView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//

import SwiftUI

struct RecipeBookRowView: View {

    let title: String
    let recipeCount: Int

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "book.fill")
                .font(.title2)
                .foregroundColor(.accentColor)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)

                Text("\(recipeCount) recipes")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
