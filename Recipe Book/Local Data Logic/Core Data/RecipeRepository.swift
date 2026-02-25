//
//  RecipeRepository.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/13.
//

import CoreData

final class RecipeRepository {

    private let context = CoreDataManager.shared.context
    
    func recipeExistsGlobally(recipeID: String) -> Bool {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", recipeID)
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error checking global bookmarks: \(error)")
            return false
        }
    }

    func recipeExists(recipeID: String, in bookID: UUID) -> Bool {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@ AND book.id == %@",
            recipeID,
            bookID as CVarArg
        )

        return (try? context.count(for: request)) ?? 0 > 0
    }

    @MainActor func saveRecipe(
        from vm: RecipeDetailViewModel,
        into book: BookEntity,
        thumbnailFileName: String
    ) {
        guard let recipe = vm.recipe else { return }

        let entity = RecipeEntity(context: context)

        entity.id = recipe.id
        entity.name = recipe.title
        entity.area = recipe.area
        entity.category = recipe.category
        entity.instructions = recipe.instructions
        entity.date = Date()
        entity.book = book
        entity.bookID = book.id?.uuidString
        entity.thumbnail = thumbnailFileName

        // Flatten ingredients into strings
        entity.ingredientName = recipe.ingredients.map { $0.name }.joined(separator: "|")
        entity.ingredientMeasure = recipe.ingredients.map { $0.measure }.joined(separator: "|")

        save()
    }

    private func save() {
        if context.hasChanges {
            do {
                try context.save()

                // 🔍 Print Core Data store location
                if let storeURL = context
                    .persistentStoreCoordinator?
                    .persistentStores
                    .first?
                    .url {
                    print("Core Data store location:")
                    print(storeURL.absoluteString)
                }

            } catch {
                print("Failed to save context:", error)
            }
        }
    }
    
    func deleteRecipe(_ recipe: RecipeEntity) {
        let fileName = recipe.thumbnail ?? ""
        let bookID = recipe.bookID ?? ""

        // Delete the image from the subfolder
        if !fileName.isEmpty && !bookID.isEmpty {
            ImageStorageManager.shared.deleteImage(fileName: fileName, bookID: bookID)
        }

        // Delete from Core Data
        context.delete(recipe)
        save()
    }
    
    func fetchRecipes(for book: BookEntity) -> [RecipeEntity] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "book == %@", book)
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true)
        ]

        return (try? context.fetch(request)) ?? []
    }
}

extension RecipeRepository {
    /// Combines duplicate ingredients so duplicates are counted and annotated
    func combinedIngredients(_ recipe: RecipeEntity) -> [String] {
        let names = recipe.ingredientName?.components(separatedBy: "|") ?? []
        let measures = recipe.ingredientMeasure?.components(separatedBy: "|") ?? []
        
        var combined: [String: Int] = [:]
        var display: [String] = []
        
        for (name, measure) in zip(names, measures) {
            let key = "\(measure) \(name)"
            if let count = combined[key] {
                combined[key] = count + 1
            } else {
                combined[key] = 1
            }
        }
        
        for (key, count) in combined {
            if count > 1 {
                display.append("\(key) x\(count)")
            } else {
                display.append(key)
            }
        }
        
        return display
    }
}
