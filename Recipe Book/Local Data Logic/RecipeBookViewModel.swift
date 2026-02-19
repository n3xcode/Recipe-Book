//
//  RecipeBookViewModel.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/19.
//

import Foundation
import UIKit

final class RecipeBookViewModel: ObservableObject {

    @Published var currentIndex: Int = 0 {
        didSet { updateWindow() }
    }

    @Published private(set) var recipes: [RecipeEntity] = []

    private let book: BookEntity
    private let repository = RecipeRepository()
    private let imageLoader = ImageWindowLoader()

    init(book: BookEntity) {
        self.book = book
        loadRecipes()
    }

    private func loadRecipes() {
        recipes = repository.fetchRecipes(for: book)

        if !recipes.isEmpty {
            currentIndex = 0
            updateWindow()
        }
    }

    func recipe(at index: Int) -> RecipeEntity {
        recipes[index]
    }

    func image(for index: Int) -> UIImage? {
        imageLoader.image(for: index)
    }

    private func updateWindow() {
        guard !recipes.isEmpty else { return }

        let lower = max(currentIndex - 1, 0)
        let upper = min(currentIndex + 1, recipes.count - 1)

        imageLoader.updateWindow(
            range: lower...upper,
            recipes: recipes
        )
    }
}
