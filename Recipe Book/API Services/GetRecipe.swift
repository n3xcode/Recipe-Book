//
//  GetRecipe.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/27.
//

import Foundation

extension GetHomePageRecipes {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        area = try container.decodeIfPresent(String.self, forKey: .area)
        instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        youtubeURL = try container.decodeIfPresent(String.self, forKey: .youtubeURL)
        
        var tempIngredients: [Ingredient] = []
        
        for index in 1...20 {
            let ingredientKey = CodingKeys(rawValue: "strIngredient\(index)")!
            let measureKey = CodingKeys(rawValue: "strMeasure\(index)")!
            
            let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey)?
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            let measure = try container.decodeIfPresent(String.self, forKey: measureKey)?
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let ingredient, !ingredient.isEmpty {
                tempIngredients.append(
                    Ingredient(name: ingredient, measure: measure ?? "")
                )
            }
        }
        
        ingredients = tempIngredients
    }
    
}

final class MealAPI {
    
    func fetchMeals(from endpoint: MealEndpoint) async throws -> [GetHomePageRecipes] {
        let (data, _) = try await URLSession.shared.data(from: endpoint.url)
        let decoded = try JSONDecoder().decode(MealsResponse.self, from: data)
        return decoded.meals
    }
}

// MARK: HomePageRecipeViewModel
@MainActor
final class HomePageRecipeViewModel: ObservableObject {

    @Published var homeMeals: [HomeMealPage] = []
    
    //@Published var isLoading = true
    //Not needed, as the view handles the loading for each preview tile.

    @Published var errorMessage: String?

    private let api = MealAPI()
    
    private var hasLoaded = false
    
    private var fetchTask: Task<Void, Never>? = nil
    
    func loadHomeMealsIfNeeded() async {
        guard !hasLoaded else {return}
        await loadHomeMeals()
        hasLoaded = true
    }

    func loadHomeMeals() async {
        
        //fetchTask cancels any previous task
        fetchTask?.cancel()
        
        fetchTask = Task {
            await MainActor.run {
                //self.isLoading = true
                self.errorMessage  = nil
            }
 

            defer {
                //Task {await MainActor.run {self.isLoading = false}}
                }
                
            
            
            do {
                async let random = api.fetchMeals(from: .random)
                async let chicken = api.fetchMeals(from: .byCategory("Chicken"))
                async let seafood = api.fetchMeals(from: .byCategory("Seafood"))
                async let dessert = api.fetchMeals(from: .byCategory("Dessert"))
                
                let results = try await [
                    random.first,
                    chicken.first,
                    seafood.first,
                    dessert.first
                ]
                
                homeMeals = results.compactMap { $0?.summary }
                
            } catch is CancellationError {
                // Normal behavior, ignore silently
            } catch {
                self.errorMessage = "Failed to load home meals. Pull to refresh."
                print("Failed to load home meals:", error)
            }
        }
        await fetchTask?.value
    }
    
    func refreshHomeMeals() async {
        await loadHomeMeals()
        hasLoaded = true
    }
}

@MainActor
final class RecipeDetailViewModel: ObservableObject {

    @Published var recipe: SelectedMealPage?

    private let api = MealAPI()

    func fetchRecipe(by id: String) async {
        do {
            let meals = try await api.fetchMeals(from: .lookup(id))

            recipe = meals.first?.selectedRecipe

        } catch {
            print("Failed to load recipe:", error)
            recipe = nil
        }
    }
}

