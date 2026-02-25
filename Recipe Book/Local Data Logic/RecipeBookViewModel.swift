//
//  RecipeBookViewModel.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/19.
//

import Foundation
import UIKit

@MainActor
final class RecipeBookViewModel: ObservableObject {
    
    private var retryTask: Task<Void, Never>?

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

    func recipe(at index: Int) -> RecipeEntity? {
        guard index >= 0 && index < recipes.count else { return nil }
        return recipes[index]
    }

    func image(for index: Int, recipes: [RecipeEntity]) -> UIImage? {
        // Safety guard
        guard recipes.indices.contains(index) else { return nil }

        // Try cache first
        if let image = imageLoader.image(for: index, recipes: Array(recipes)) {
            return image
        }

        // Attempt to load immediately from disk if missing
        let recipe = recipes[index]
        if let fileName = recipe.thumbnail,
           let bookID = recipe.bookID,
           let image = imageLoader.loadImage(fileName: fileName, bookID: bookID) {
            // Cache it for future requests
            imageLoader.cache[index] = image
            return image
        }

        // Schedule a short retry asynchronously
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.objectWillChange.send() // Trigger SwiftUI update
        }

        // Still return nil for now; SwiftUI will refresh soon
        return nil
    }
    
    private func retryImageLoad(after delay: Double) {
        retryTask?.cancel()

        retryTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))

            updateWindow()
            objectWillChange.send()
        }
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
    
    func deleteCurrentRecipe() {
        guard !recipes.isEmpty else { return }

        let deletingIndex = currentIndex
        let recipeToDelete = recipes[deletingIndex]

        repository.deleteRecipe(recipeToDelete)

        let updatedRecipes = repository.fetchRecipes(for: book)

        // If book is now empty → update state and return
        if updatedRecipes.isEmpty {
            recipes = []
            currentIndex = 0
            return
        }

        // Decide where to move BEFORE assigning recipes
        var newIndex = deletingIndex

        if deletingIndex > 0 {
            newIndex = deletingIndex - 1
        } else {
            newIndex = 0
        }

        // Assign recipes
        recipes = updatedRecipes

        // Clamp index safely
        currentIndex = min(newIndex, recipes.count - 1)

        updateWindow()
    }
}
