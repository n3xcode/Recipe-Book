//
//  HomePageRecipeView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/23.
//

import SwiftUI

struct HomePageRecipeView: View {

    let mealID: String
    @StateObject private var vm = RecipeDetailViewModel()

    var body: some View {
        ScrollView {
            if let recipe = vm.recipe {
                VStack(alignment: .leading, spacing: 16) {

                    Text(recipe.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    AsyncImage(url: URL(string: recipe.thumbnail ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(height: 200)
                    .cornerRadius(12)
                    .clipped()

                    Text("Ingredients")
                        .font(.title2)
                        .fontWeight(.semibold)

                    ForEach(recipe.ingredients.indices, id: \.self) { index in
                        let ingredient = recipe.ingredients[index]
                        Text("• \(ingredient.measure) \(ingredient.name)")
                    }

                    Divider()

                    Text("Instructions")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(recipe.instructions ?? "")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                .padding()
            } else {
                ProgressView("Loading recipe...")
                    .padding()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.fetchRecipe(by: mealID)
        }
    }
}



struct HomePageRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageRecipeView(mealID: "52949")
    }
}
