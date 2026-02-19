//
//  ImageWindowLoader.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/19.
//

import Foundation
import UIKit

final class ImageWindowLoader {

    private var cache: [Int: UIImage] = [:]

    func image(for index: Int) -> UIImage? {
        cache[index]
    }

    func updateWindow(range: ClosedRange<Int>, recipes: [RecipeEntity]) {

        // Remove outside window
        cache.keys
            .filter { !range.contains($0) }
            .forEach { cache.removeValue(forKey: $0) }

        // Load missing inside window
        for index in range {
            guard cache[index] == nil else { continue }

            let recipe = recipes[index]

            if let fileName = recipe.thumbnail,
               let image = loadImage(fileName: fileName) {
                cache[index] = image
            }
        }
    }

    private func loadImage(fileName: String) -> UIImage? {
        let url = ImageStorageManager.shared.fileURL(for: fileName)
        return UIImage(contentsOfFile: url.path)
    }
}
