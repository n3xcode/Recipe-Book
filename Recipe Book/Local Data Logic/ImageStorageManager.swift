//
//  ImageStorageManager.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/11.
//

import Foundation
import UIKit

class ImageStorageManager {
    
    static let shared = ImageStorageManager()
    private init() {}
    
    private var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory,
                                 in: .userDomainMask)[0]
    }
    
    func fileURL(for fileName: String) -> URL {
        documentsURL.appendingPathComponent(fileName)
    }
    
    func fileExists(fileName: String) -> Bool {
        let path = fileURL(for: fileName).path
        return FileManager.default.fileExists(atPath: path)
    }
}

@MainActor
final class SaveRecipeImg: ObservableObject {
    @Published var isBookmarked: Bool = false
    @Published var savedImage: UIImage? = nil
    
    private let repository = RecipeRepository()

    func checkIfBookmarked(mealID: String) {
        self.isBookmarked = repository.recipeExistsGlobally(recipeID: mealID)
    }

    // Changed to 'async'
    func saveImageToDisk(getRecipeImgUrl: String) async {
        guard let url = URL(string: getRecipeImgUrl), !getRecipeImgUrl.isEmpty else { return }
        
        let fileName = url.lastPathComponent
        let fileURL = ImageStorageManager.shared.fileURL(for: fileName)
        
        if ImageStorageManager.shared.fileExists(fileName: fileName) {
            self.isBookmarked = true
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            try data.write(to: fileURL)
            
            ImageStorageManager.shared.addSkipBackupAttribute(to: fileURL)
            
            self.isBookmarked = true
        } catch {
            print("Failed to save image: \(error)")
        }
    }
}

//img dont get back-up to icloud
extension ImageStorageManager {
    func addSkipBackupAttribute(to url: URL) {
        do {
            var mutableURL = url
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try mutableURL.setResourceValues(resourceValues)
            print("Successfully excluded \(url.lastPathComponent) from backup")
        } catch {
            print("Failed to exclude from backup: \(error)")
        }
    }
}

