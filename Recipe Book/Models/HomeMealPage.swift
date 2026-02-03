//
//  HomeMealPage.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/23.
//

import Foundation

struct HomeMealPage: Identifiable, Hashable {
    let id: String
    let title: String
    let thumbnail: String
    let subtitle: String
}

struct SelectedMealPage: Identifiable {
    let id: String
    let title: String
    let thumbnail: String
    let subtitle: String
    let instructions: String
    let ingredients: [GetHomePageRecipes.Ingredient]
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

extension GetHomePageRecipes {
    var selectedRecipe: SelectedMealPage {
        SelectedMealPage(
            id: id,
            title: name,
            thumbnail: thumbnail ?? "",
            subtitle: area ?? "",
            instructions: instructions ?? "",
            ingredients: ingredients
        )
    }
}


