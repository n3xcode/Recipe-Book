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
        saveImgVM: SaveRecipeImg,
        allowDuplicate: Bool
    ) async -> SaveResult { // 1. Added 'async' here

        guard let recipe = vm.recipe,
              let bookID = book.id else {
            return .failed
        }

        let exists = recipeRepo.recipeExists(recipeID: recipe.id, in: bookID)

        if exists && !allowDuplicate {
            return .duplicateFound
        }

        // Extract the filename
        guard let url = URL(string: recipe.thumbnail) else { return .failed }
        let fileName = url.lastPathComponent

        // Save the metadata to Core Data
        recipeRepo.saveRecipe(
            from: vm,
            into: book,
            thumbnailFileName: fileName
        )

        await saveImgVM.saveImageToDisk(
            getRecipeImgUrl: recipe.thumbnail,
            bookID: bookID.uuidString // Pass the ID here
        )

        return .success
    }
}

enum SaveResult {
    case success
    case duplicateFound
    case failed
}
