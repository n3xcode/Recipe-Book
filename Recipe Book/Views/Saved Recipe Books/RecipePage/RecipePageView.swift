//
//  MyRecipesView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

struct RecipePageView: View {

    let recipe: RecipeEntity
    let image: UIImage?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text(recipe.name ?? "Untitled")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                if let image {
                    Image(uiImage: image)
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

                ForEach(parseIngredients(recipe), id: \.self) { item in
                    Text("• \(item)")
                }

                Divider()

                Text("Instructions")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(recipe.instructions ?? "")
            }
            .padding()
        }
    }
    private func parseIngredients(_ recipe: RecipeEntity) -> [String] {
        let names = recipe.ingredientName?.components(separatedBy: "|") ?? []
        let measures = recipe.ingredientMeasure?.components(separatedBy: "|") ?? []
        return zip(measures, names).map { "\($0) \($1)" }
    }
}



//struct RecipePageView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipePageView()
//    }
//}
