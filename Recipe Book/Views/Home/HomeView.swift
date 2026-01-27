//
//  HomeView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModle = HomePageRecipeViewModel()
    @State private var randomMeal: GetHomePageRecipes?
    @State private var searchText: String = ""
    
    
    
    var body: some View {
        
        NavigationView {
            
            let mealsOfTheDay: [HomeMealTile] = [
                HomeMealTile(title: randomMeal?.strMeal ?? "Random Meal", thumbnail: randomMeal?.strMealThumb ?? "", subtitle: "Feeling Lucky?"),
                HomeMealTile(title: "Chicken", thumbnail: "chicken", subtitle: "chicken"),
                HomeMealTile(title: "Seafood", thumbnail: "seafood", subtitle: "seafood"),
                HomeMealTile(title: "Dessert", thumbnail: "dessert", subtitle: "dessert")
            ]
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    SearchBarView(searchText: $searchText)
                    
                    Text("Meals of the Day")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 35
                    ) {
                        ForEach(mealsOfTheDay) { meal in
                            NavigationLink(
                                destination: HomePageRecipeView()
                            ) {
                                //might need to await for the api call before the defaults are triggered
                                RecipeTileView(
                                    title: meal.title, subtitle: meal.subtitle,
                                    imageName: meal.thumbnail
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
        }
        .task {
            do {
                randomMeal = try await viewModle.loadHomePageRandomRecipe()
            } catch RecipeError.invalidURL {
                print("Yikes no URL found")
            } catch RecipeError.invalidResponse {
                print("Yikes bad response")
            } catch RecipeError.invalidData {
                print("Yikes no data found")
            }  catch {
                print("Big Yikes!!")
            }
        }
        
        
    }
    
}




struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

