//
//  HomeView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

struct HomeView: View {
    
    @State private var searchText: String = ""
    
    let mealsOfTheDay: [HomeMealTile] = [
        HomeMealTile(title: "Pasta", thumbnail: "pasta", query: "pasta"),
        HomeMealTile(title: "Chicken", thumbnail: "chicken", query: "chicken"),
        HomeMealTile(title: "Seafood", thumbnail: "seafood", query: "seafood"),
        HomeMealTile(title: "Dessert", thumbnail: "dessert", query: "dessert")
    ]
    
    var body: some View {
        
        NavigationView {
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
                                destination: HomePageRecipeView(query: meal.query)
                            ) {
                                RecipeTileView(
                                    title: meal.title, subtitle: meal.title,
                                    imageName: meal.thumbnail
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
        }
        
    }
    
}




struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

