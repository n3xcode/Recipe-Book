//
//  MyRecipesView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

struct RecipePageView: View {

    let recipeIndex: Int
    
    @State private var savedImage: UIImage? = nil
    
    // For testing, using hardcoded URL as "filename"
    private var fileName: String {
        "o5fuq51764789643.jpg" // just the name, not full URL
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text("Recipe \(recipeIndex + 1)")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Conditional image
                if let savedImage {
                    Image(uiImage: savedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .cornerRadius(12)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .cornerRadius(12)
                }

                Text("Ingredients")
                    .font(.title2)
                    .fontWeight(.semibold)

                ForEach(0..<5, id: \.self) { _ in
                    Text("• Ingredient item")
                }

                Divider()

                Text("Instructions")
                    .font(.title2)
                    .fontWeight(.semibold)

                ForEach(0..<4, id: \.self) { step in
                    Text("\(step + 1). Instruction step goes here.")
                }
            }
            .padding()
        }
        // Async load only when view appears
        .task {
            await loadImageAsync()
        }
    }
    
    // MARK: Async Image Loader
    private func loadImageAsync() async {
        
        await Task.detached(priority: .background) {
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileName)
            
            var image: UIImage? = nil
            
            // ✅ Only check if the file exists
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


}


struct RecipePageView_Previews: PreviewProvider {
    static var previews: some View {
        RecipePageView(recipeIndex: 0)
    }
}
