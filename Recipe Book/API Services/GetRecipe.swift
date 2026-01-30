//
//  GetRecipe.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/27.
//

import Foundation

struct MealsResponse: Decodable {
    let meals: [GetHomePageRecipes]
}

struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let measure: String
}

struct GetHomePageRecipes: Decodable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let strInstructions: String

    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?

    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?
}


extension GetHomePageRecipes {

    var ingredients: [Ingredient] {
        var result: [Ingredient] = []

        let mirror = Mirror(reflecting: self)

        let ingredients = mirror.children
            .filter { $0.label?.starts(with: "strIngredient") == true }
            .compactMap { $0.value as? String }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        let measures = mirror.children
            .filter { $0.label?.starts(with: "strMeasure") == true }
            .compactMap { $0.value as? String }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        for index in 0..<min(ingredients.count, measures.count) {
            guard !ingredients[index].isEmpty else { continue }

            result.append(
                Ingredient(
                    name: ingredients[index],
                    measure: measures[index]
                )
            )
        }

        return result
    }
    
    //view code
    /*
     ForEach(recipe.ingredients) { ingredient in
         HStack {
             Text(ingredient.name)
             Spacer()
             Text(ingredient.measure)
                 .foregroundColor(.secondary)
         }
     }
     */
}

final class HomePageRecipeViewModel: ObservableObject {
    
    
    // MARK: - Home Page Random Recipe
    @Published var homePageRandomRecipe: [GetHomePageRecipes] = []
    
    func loadHomePageRandomRecipe() async throws {
        
        let randomMeal = "https://www.themealdb.com/api/json/v1/1/random.php"
        print ("fine :)")
        guard let randomMealUrl = URL(string: randomMeal) else { throw RecipeError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: randomMealUrl)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw RecipeError.invalidResponse }
        
        let decoded = try JSONDecoder().decode(MealsResponse.self, from: data)
        
        DispatchQueue.main.async {
            self.homePageRandomRecipe = decoded.meals
        }
    }
    
    
    
}
