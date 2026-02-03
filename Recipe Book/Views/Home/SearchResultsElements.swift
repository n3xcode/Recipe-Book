//
//  SearchResultsElements.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/03.
//

import SwiftUI

struct SearchResultsDropdown: View {

    let meals: [HomeMealPage]
    let query: String
    let onSelect: (HomeMealPage) -> Void // parent handles clearing search

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(meals) { meal in
                    NavigationLink(
                        destination: HomePageRecipeView(mealID: meal.id)
                            .onAppear {
                                // parent decides what to do when navigation occurs
                                onSelect(meal)
                            }
                    ) {
                        SearchResultRow(meal: meal, query: query)
                    }
                    Divider()
                }
            }
        }
        .frame(maxHeight: 280)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 6)
    }
}




struct SearchResultRow: View {

    let meal: HomeMealPage
    let query: String

    var body: some View {
        HStack(spacing: 12) {

            AsyncImage(url: URL(string: meal.thumbnail)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 44, height: 44)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(highlightedTitle)
                .font(.subheadline)
                .lineLimit(1)

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
    }

    private var highlightedTitle: AttributedString {
        var attributed = AttributedString(meal.title)

        guard
            !query.isEmpty,
            let range = attributed.range(
                of: query,
                options: .caseInsensitive
            )
        else {
            return attributed
        }

        attributed[range].foregroundColor = .orange
        attributed[range].font = .subheadline.bold()

        return attributed
    }
}

