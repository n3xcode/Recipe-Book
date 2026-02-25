//
//  ImageWindowLoader.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/19.
//

import Foundation
import UIKit

final class ImageWindowLoader: ObservableObject {

    var cache: [Int: UIImage] = [:]

    func image(for index: Int, recipes: [RecipeEntity]) -> UIImage? {
        if let img = cache[index] {
            return img
        }

        // Lazy load immediately if missing
        guard index < recipes.count else { return nil }
        let recipe = recipes[index]

        if let fileName = recipe.thumbnail,
           let bookID = recipe.bookID,
           let img = loadImage(fileName: fileName, bookID: bookID) {
            cache[index] = img
            return img
        }

        return nil
    }

    func updateWindow(range: ClosedRange<Int>, recipes: [RecipeEntity]) {
        // Remove out-of-window images
        cache.keys.filter { !range.contains($0) }.forEach { cache.removeValue(forKey: $0) }

        // Load images in window asynchronously
        for index in range {
            guard index < recipes.count else { continue }
            guard cache[index] == nil else { continue }

            let recipe = recipes[index]

            if let fileName = recipe.thumbnail,
               let bookID = recipe.bookID,
               let image = loadImage(fileName: fileName, bookID: bookID) {
                cache[index] = image
            }
        }
    }

    func loadImage(fileName: String, bookID: String) -> UIImage? {
        let url = ImageStorageManager.shared.fileURL(for: fileName, bookID: bookID)
        return UIImage(contentsOfFile: url.path)
    }
}
