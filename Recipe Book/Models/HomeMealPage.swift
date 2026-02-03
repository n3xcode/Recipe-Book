//
//  HomeMealPage.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/23.
//

import Foundation

struct HomeMealPage: Identifiable, Hashable {
    let id: String
    let title: String
    let thumbnail: String
    let subtitle: String
}

struct SelectedMealPage: Identifiable {
    let id: String
    let title: String
    let thumbnail: String
    let subtitle: String
    let instructions: String
    let ingredients: [GetHomePageRecipes.Ingredient]
}

extension GetHomePageRecipes {
    var summary: HomeMealPage {
        HomeMealPage(
            id: id,
            title: name,
            thumbnail: thumbnail ?? "",
            subtitle: area ?? ""
        )
    }
}

extension GetHomePageRecipes {
    var selectedRecipe: SelectedMealPage {
        SelectedMealPage(
            id: id,
            title: name,
            thumbnail: thumbnail ?? "",
            subtitle: area ?? "",
            instructions: instructions ?? "",
            ingredients: ingredients
        )
    }
}

// move out to api
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

