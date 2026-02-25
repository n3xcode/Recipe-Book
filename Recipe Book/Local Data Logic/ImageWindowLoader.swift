//
//  ImageWindowLoader.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/19.
//

import Foundation
import UIKit

final class ImageWindowLoader: ObservableObject{

    private var cache: [Int: UIImage] = [:]

    func image(for index: Int) -> UIImage? {
        cache[index]
    }

    func updateWindow(range: ClosedRange<Int>, recipes: [RecipeEntity]) {

        // remove images outside the current window to save RAM
        cache.keys
            .filter { !range.contains($0) }
            .forEach { cache.removeValue(forKey: $0) }

        // load missing images inside the window
        for index in range {
            guard index < recipes.count else { continue } // Safety check
            guard cache[index] == nil else { continue }

            let recipe = recipes[index]

            // filename and the bookID to the loader
            if let fileName = recipe.thumbnail,
               let bookID = recipe.bookID, // Extracting the folder name
               let image = loadImage(fileName: fileName, bookID: bookID) {
                cache[index] = image
            }
        }
    }

    private func loadImage(fileName: String, bookID: String) -> UIImage? {
        let url = ImageStorageManager.shared.fileURL(for: fileName, bookID: bookID)
        
        return UIImage(contentsOfFile: url.path)
    }
}
