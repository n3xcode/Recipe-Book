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

    @Published var homeMeals: [SelectedMealPage] = []
    @Published var errorMessage: String?

    private let api: MealAPI
    private var hasLoaded = false
    private var fetchTask: Task<Void, Never>? = nil

    init(api: MealAPI) {
        self.api = api
    }

    func loadHomeMealsIfNeeded() async {
        guard !hasLoaded else { return }
        await loadHomeMeals()
        hasLoaded = true
    }

    func loadHomeMeals() async {
        // Cancel any existing fetch
        fetchTask?.cancel()
        
        fetchTask = Task { [weak self] in
            guard let self = self else { return }
            
            await MainActor.run { self.errorMessage = nil }
            var seenIDs = Set<String>()
            
            do {
                //let categories = ["Chicken", "Seafood", "Dessert"] *user selections WIP*
                
                // concurrent calls
                async let chickenMeals = self.api.fetchMeals(from: .byCategory("Chicken"))
                async let seafoodMeals = self.api.fetchMeals(from: .byCategory("Seafood"))
                async let dessertMeals = self.api.fetchMeals(from: .byCategory("Dessert"))
                
                let categoryResults = try await [chickenMeals, seafoodMeals, dessertMeals]
                
                // Prepare lookup tasks for random meal per category
                var lookupTasks: [Task<SelectedMealPage?, Never>] = []
                
                for meals in categoryResults {
                    if let randomMeal = meals.randomElement(),
                       !seenIDs.contains(randomMeal.id) {
                        seenIDs.insert(randomMeal.id)
                        
                        let task = Task { () -> SelectedMealPage? in
                            try? await self.api.fetchMeals(from: .lookup(randomMeal.id))
                                .first?.selectedRecipe
                        }
                        lookupTasks.append(task)
                    }
                }
                
                //TheMealDB API doesn’t support fetching by index within a category
                // Fetch random meal concurrently
                let randomMeals = try await self.api.fetchMeals(from: .random)
                if let randomMeal = randomMeals.first,
                   !seenIDs.contains(randomMeal.id) {
                    seenIDs.insert(randomMeal.id)
                    
                    let randomTask = Task { () -> SelectedMealPage? in
                        try? await self.api.fetchMeals(from: .lookup(randomMeal.id))
                            .first?.selectedRecipe
                    }
                    lookupTasks.insert(randomTask, at: 0) // insert random meal first
                }

                var fullMeals: [SelectedMealPage] = []

                for task in lookupTasks {
                    if let meal = await task.value {
                        fullMeals.append(meal)
                    }
                }

                await MainActor.run {
                    self.homeMeals = fullMeals
                    if fullMeals.isEmpty {
                        self.errorMessage = "No meals found. Pull to refresh."
                    }
                }
                
            } catch is CancellationError {
                return
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load home meals. Pull to refresh."
                }
                print("Failed to load meals:", error)
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

