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
    let onSelect: (HomeMealPage) -> Void
    
    var body: some View {
        List {
            ForEach(meals) { meal in
                if meal.id == "no_results" {
                    VStack {
                        Text(meal.title)
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text(meal.area)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    
                } else {
                    // --- UPDATED HERE ---
                    // Replace NavigationLink with a Button
                    Button {
                        onSelect(meal)
                    } label: {
                        SearchResultRow(meal: meal, query: query)
                            // Makes the entire row area tappable
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    // --------------------
                }
            }
        }
        .listStyle(.plain)
        .frame(maxHeight: 280)
        .scrollContentBackground(.hidden)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 6)
    }
}




struct SearchResultRow: View {

    let meal: HomeMealPage
    let query: String

    @StateObject private var loader: ImageLoader

    init(meal: HomeMealPage, query: String) {
        self.meal = meal
        self.query = query
        _loader = StateObject(
            wrappedValue: ImageLoader(
                url: URL(string: meal.thumbnail)
            )
        )
    }

    var body: some View {
        HStack(spacing: 12) {

            thumbnailView

            Text(highlightedTitle)
                .font(.subheadline)
                .lineLimit(1)

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
    }

    private var thumbnailView: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.gray.opacity(0.15)
            }
        }
        .frame(width: 44, height: 44)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var highlightedTitle: AttributedString {
        var attributed = AttributedString(meal.title)

        if let range = attributed.range(of: query, options: .caseInsensitive) {
            attributed[range].foregroundColor = .orange
            attributed[range].font = .subheadline.bold()
        }

        return attributed
    }
}
