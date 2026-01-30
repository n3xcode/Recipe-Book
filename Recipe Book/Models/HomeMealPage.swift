//
//  HomeMealPage.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/23.
//

import Foundation

struct HomeMealPage: Identifiable {
    let id: String
    let title: String
    let thumbnail: String   // image name or URL later
    let subtitle: String       //
}

extension GetHomePageRecipes {
    var summary: HomeMealPage {
        HomeMealPage(
            id: id,
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

@MainActor
final class RecipeDetailViewModel: ObservableObject {

    @Published var recipe: GetHomePageRecipes?
    
    private let api = MealAPI()

    func fetchRecipe(by id: String) async {
        do {
            async let selectedRecipe = api.fetchMeals(from: .lookup(id))

            let results = try await [
                selectedRecipe.first
            ]
            
            //recipe = results.Map { $0?.GetHomePageRecipes }

        } catch {
            print("Failed to load home meals:", error)
        }
    }
}

