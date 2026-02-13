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
    @Published var errorMessage: String?

    let api = MealAPI()
    
    private var hasLoaded = false
    private var fetchTask: Task<Void, Never>? = nil
    
    func loadHomeMealsIfNeeded() async {
        guard !hasLoaded else { return }
        await loadHomeMeals()
        hasLoaded = true
    }

    func loadHomeMeals() async {
        fetchTask?.cancel()
        
        fetchTask = Task {
            await MainActor.run { self.errorMessage = nil }
            
            do {
                // 1️⃣ Fetch categories + random concurrently
                async let chickenTask = api.fetchMeals(from: .byCategory("Chicken"))
                async let seafoodTask = api.fetchMeals(from: .byCategory("Seafood"))
                async let dessertTask = api.fetchMeals(from: .byCategory("Dessert"))
                async let randomTask = api.fetchMeals(from: .random)
                
                let chickenResponse = try await chickenTask
                let seafoodResponse = try await seafoodTask
                let dessertResponse = try await dessertTask
                let randomResponse = try await randomTask
                
                var finalMeals: [HomeMealPage] = []
                var seenIDs = Set<String>()
                
                func addIfUnique(_ meal: HomeMealPage?) {
                    guard let meal = meal else { return }
                    guard !seenIDs.contains(meal.id) else { return }
                    finalMeals.append(meal)
                    seenIDs.insert(meal.id)
                }
                
                // 2️⃣ Add one random from each category
                addIfUnique(chickenResponse.randomElement()?.summary)
                addIfUnique(seafoodResponse.randomElement()?.summary)
                addIfUnique(dessertResponse.randomElement()?.summary)
                
                // 3️⃣ Insert truly random meal at front
                var randomInserted = false
                
                if let randomMeal = randomResponse.first?.summary,
                   !seenIDs.contains(randomMeal.id) {
                    finalMeals.insert(randomMeal, at: 0)
                    seenIDs.insert(randomMeal.id)
                    randomInserted = true
                }
                
                // 4️⃣ Retry random if duplicate (max 3 attempts)
                var attempts = 0
                while !randomInserted && attempts < 3 {
                    attempts += 1
                    
                    if let retryMeal = try await api.fetchMeals(from: .random)
                        .first?.summary,
                       !seenIDs.contains(retryMeal.id) {
                        
                        finalMeals.insert(retryMeal, at: 0)
                        seenIDs.insert(retryMeal.id)
                        randomInserted = true
                    }
                }
                
                // 5️⃣ Safety fallback (ensures UI always has data)
                if finalMeals.isEmpty {
                    self.errorMessage = "No meals found. Pull to refresh."
                }
                
                self.homeMeals = finalMeals
                
            } catch is CancellationError {
                return
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

