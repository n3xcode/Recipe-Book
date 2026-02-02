//
//  HomeView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var vm = HomePageRecipeViewModel()
    @State private var searchText: String = ""

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

                        ForEach(vm.homeMeals) { meal in
                            NavigationLink(
                                destination: HomePageRecipeView(mealID: meal.id)
                            ) {
                                RecipeTileView(
                                    title: meal.title,
                                    subtitle: meal.subtitle,
                                    imageName: meal.thumbnail
                                )
                            }
                        }

                        // Optional: placeholders img while loading
                        if vm.homeMeals.isEmpty {
                            ForEach(0..<4, id: \.self) { _ in
                                RecipeTileView(
                                    title: "Loading...",
                                    subtitle: "",
                                    imageName: ""
                                )
                                .redacted(reason: .placeholder)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("")
            .refreshable {
                await vm.refreshHomeMeals()
            }
            .task {
                await vm.loadHomeMealsIfNeeded()
            }
        }
    }
}





struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

