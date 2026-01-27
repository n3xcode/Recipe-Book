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
