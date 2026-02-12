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
    var getRecipeImgUrl = ""
    var isBookmarked:Bool = false
    
    //MARK: load Img
    //for now delete img in session later link to Meal img id in core data
    @Published var savedImage: UIImage? = nil
    
    func loadImageAsync(getImgId: String) async {
        
        await Task.detached(priority: .background) {
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(getImgId)
            
            var image: UIImage? = nil
            
            // Only check if the file exists
            if FileManager.default.fileExists(atPath: fileURL.path) {
                image = UIImage(contentsOfFile: fileURL.path)
            }
            
            // Update UI on main thread if we found the image
            if let image {
                await MainActor.run {
                    self.savedImage = image
                }
            }
            // If the image is nil (file missing), savedImage stays nil → placeholder shows
        }.value
    }
    
    //MARK: Save Img
    
    func saveImageToDisk(getRecipeImgUrl: String) {

        guard let url = URL(string: getRecipeImgUrl) else { return }
        
        // Use the last path component of the URL as filename
        let fileName = url.lastPathComponent
        let fileURL = ImageStorageManager.shared.fileURL(for: fileName)
        
        if ImageStorageManager.shared.fileExists(fileName: fileName) || getRecipeImgUrl == "" {
            isBookmarked = true
            print("Image already saved or no url path")
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

