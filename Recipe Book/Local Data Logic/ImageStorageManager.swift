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
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // Get the folder for a specific book
    func bookFolderURL(for bookID: String) -> URL {
        return documentsURL.appendingPathComponent(bookID)
    }
    
    // Updated to include bookID
    func fileURL(for fileName: String, bookID: String) -> URL {
        return bookFolderURL(for: bookID).appendingPathComponent(fileName)
    }
    
    // MARK: - Cleanup Methods
    
    func deleteImage(fileName: String, bookID: String) {
        let url = fileURL(for: fileName, bookID: bookID)
        try? FileManager.default.removeItem(at: url)
    }
    
    func deleteBookFolder(bookID: String) {
        let url = bookFolderURL(for: bookID)
        try? FileManager.default.removeItem(at: url)
        print("Deleted folder for book: \(bookID)")
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
    func saveImageToDisk(getRecipeImgUrl: String, bookID: String) async {
        guard let url = URL(string: getRecipeImgUrl), !getRecipeImgUrl.isEmpty else { return }
        
        let fileName = url.lastPathComponent
        let folderURL = ImageStorageManager.shared.bookFolderURL(for: bookID)
        let fileURL = ImageStorageManager.shared.fileURL(for: fileName, bookID: bookID)
        
        do {
            // Create the book folder if it doesn't exist yet
            if !FileManager.default.fileExists(atPath: folderURL.path) {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            }
            
            // If file exists, return
            if FileManager.default.fileExists(atPath: fileURL.path) {
                self.isBookmarked = true
                return
            }
            
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

