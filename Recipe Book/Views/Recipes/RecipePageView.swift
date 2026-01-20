//
//  MyRecipesView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

struct RecipePageView: View {

    let recipeIndex: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text("Recipe \(recipeIndex + 1)")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .cornerRadius(12)

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
    }
}

struct RecipePageView_Previews: PreviewProvider {
    static var previews: some View {
        RecipePageView(recipeIndex: 0)
    }
}
