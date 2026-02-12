//
//  MyRecipesView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

struct RecipePageView: View {
    
    @StateObject private var vm = RecipeDetailViewModel()
    //private var getImgId = vm.recipe
    @StateObject private var svImg = SaveRecipeImg()
    let recipeIndex: Int
    
    // For testing, using hardcoded URL as "filename"
    var hasFileName: String = "o5fuq51764789643.jpg"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text("Recipe \(recipeIndex + 1)")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Conditional image
                if svImg.savedImage != nil {
                    Image(uiImage: svImg.savedImage!)
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
            if (hasFileName != "") {
                await svImg.loadImageAsync(getImgId: hasFileName)
                print("if = \(hasFileName)")
            } else {
                print("Thumbnail is nil. Recipe:", "else = \(hasFileName)")
            }
        }
    }
}


struct RecipePageView_Previews: PreviewProvider {
    static var previews: some View {
        RecipePageView(recipeIndex: 0, hasFileName: "o5fuq51764789643.jpg")
    }
}
