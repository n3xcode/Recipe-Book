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
final class SaveRecipeImg: ObservableObject{
    
    //get recipe id -> img url
    private let testImageURL = "https://www.themealdb.com/images/media/meals/o5fuq51764789643.jpg"
    var isBookmarked:Bool = false
    
    func saveImageToDisk() {

        guard let url = URL(string: testImageURL) else { return }
        
        // Use the last path component of the URL as filename
        let fileName = url.lastPathComponent
        let fileURL = ImageStorageManager.shared.fileURL(for: fileName)
        
        if ImageStorageManager.shared.fileExists(fileName: fileName) {
            isBookmarked = true
            print("Image already saved")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                print("Download error:", error)
                return
            }
            
            guard let data = data else {
                print("Download failed: no data")
                return
            }
            
            do {
                try data.write(to: fileURL)
                
                DispatchQueue.main.async {
                    self.isBookmarked = true
                    print("Image saved at:", fileURL)
                }
                
            } catch {
                print("File save error:", error)
            }
            
        }.resume()
    }
}

