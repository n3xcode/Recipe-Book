//
//  SaveRecipeCoordinator.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/13.
//

import Foundation

final class SaveRecipeCoordinator {

    private let recipeRepo = RecipeRepository()

    @MainActor func handleSave(
        vm: RecipeDetailViewModel,
        book: BookEntity,
        thumbnailFileName: String,
        allowDuplicate: Bool
    ) -> SaveResult {

        guard let recipeID = vm.recipe?.id,
              let bookID = book.id else {
            return .failed
        }

        let exists = recipeRepo.recipeExists(
            recipeID: recipeID,
            in: bookID
        )

        if exists && !allowDuplicate {
            return .duplicateFound
        }

        recipeRepo.saveRecipe(
            from: vm,
            into: book,
            thumbnailFileName: thumbnailFileName
        )

        return .success
    }
}

enum SaveResult {
    case success
    case duplicateFound
    case failed
}
