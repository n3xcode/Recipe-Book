//
//  HomeMealPage.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/23.
//

import Foundation

struct HomeMealPage: Identifiable {
    let id = UUID()
    let title: String
    let thumbnail: String   // image name or URL later
    let subtitle: String       //
}

extension GetHomePageRecipes {
    var summary: HomeMealPage {
        HomeMealPage(
            title: name,
            thumbnail: thumbnail ?? "",
            subtitle: area ?? ""
        )
    }
}

@MainActor
final class HomePageRecipeViewModel: ObservableObject {

    @Published var homeMeals: [HomeMealPage] = []

    private let api = MealAPI()

    func loadHomeMeals() async {
        do {
            async let random = api.fetchMeals(from: .random)
            async let chicken = api.fetchMeals(from: .byCategory("Chicken"))
            async let seafood = api.fetchMeals(from: .byCategory("Seafood"))
            async let dessert = api.fetchMeals(from: .byCategory("Dessert"))

            let results = try await [
                random.first,
                chicken.first,
                seafood.first,
                dessert.first
            ]

            homeMeals = results.compactMap { $0?.summary }

        } catch {
            print("Failed to load home meals:", error)
        }
    }
}

