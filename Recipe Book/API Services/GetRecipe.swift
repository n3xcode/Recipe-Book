//
//  GetRecipe.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/27.
//

import Foundation

struct GetHomePageRecipes: Decodable {
    //id, name, img, ingredient with measure, Instructions add more later
    
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let strIngredient: String //strIngredient 1 -20 eg, strIngredient1, strIngredient2...
    let strMeasure1: String // same as strIngredient 1-20
    let strInstructions: String
    
}

final class HomePageRecipeViewModel: ObservableObject {
    
    
    // MARK: - Home Page Random Recipe
    @Published var homePageRandomRecipe: [GetHomePageRecipes] = []

    func loadHomePageRandomRecipe() async throws ->  GetHomePageRecipes {
        let randomMeal = "www.themealdb.com/api/json/v1/1/random.php"
        
        guard let randomMealUrl = URL(string: randomMeal) else { throw RecipeError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: randomMealUrl)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw RecipeError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(GetHomePageRecipes.self, from: data)
        } catch {
            throw RecipeError.invalidData
        }
        
    }
    
    
    
}
