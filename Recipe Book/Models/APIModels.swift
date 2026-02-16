//
//  APIModels.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/03.
//

import Foundation

//MARK: Endpoints
enum MealEndpoint {
    case random
    case search(String)
    case byCategory(String)
    case lookup(String)
    
    var url: URL {
        var components = URLComponents(string: "https://www.themealdb.com/api/json/v1/1")!
        
        switch self {
        case .random:
            components.path += "/random.php"
            
        case .search(let query):
            components.path += "/search.php"
            components.queryItems = [
                URLQueryItem(name: "s", value: query)
            ]
            
        case .byCategory(let category):
            components.path += "/filter.php"
            components.queryItems = [
                URLQueryItem(name: "c", value: category)
            ]
            
        case .lookup(let id):
            components.path += "/lookup.php"
            components.queryItems = [
                URLQueryItem(name: "i", value: id)
            ]
        }
        
        return components.url!
    }
}

enum HomeTileFilter {
    case category(String)
    case area(String)
    case ingredient(String)
    case random
}

//MARK: Meal JSON Models
struct MealsResponse: Decodable {
    let meals: [GetHomePageRecipes]
}

struct Ingredient: Identifiable {
    let id: String
    let name: String
    let measure: String
}

struct GetHomePageRecipes: Decodable {
    let id: String
    let name: String
    let category: String?
    let area: String?
    let instructions: String?
    let thumbnail: String?
    let youtubeURL: String?
    
    // Raw ingredient + measure fields
    let ingredients: [Ingredient]
    
    struct Ingredient {
        let name: String
        let measure: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case category = "strCategory"
        case area = "strArea"
        case instructions = "strInstructions"
        case thumbnail = "strMealThumb"
        case youtubeURL = "strYoutube"
        
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5
        case strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10
        case strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        case strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5
        case strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10
        case strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15
        case strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }
}

