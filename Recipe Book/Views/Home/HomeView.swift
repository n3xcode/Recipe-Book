//
//  HomeView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var vm: HomePageRecipeViewModel
    @StateObject private var searchVM: MealSearchViewModel
    @State private var searchText: String = ""

    init() {
        let homeVM = HomePageRecipeViewModel()
        _vm = StateObject(wrappedValue: homeVM)
        _searchVM = StateObject(
            wrappedValue: MealSearchViewModel(api: homeVM.api)
        )
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        // Search bar (stays in layout)
                        VStack(alignment: .leading, spacing: 6) {
                            SearchBarView(searchText: $searchText)
                                .onChange(of: searchText) { newValue in
                                    searchVM.onQueryChange(newValue)
                                }
                        }
                        .padding(.horizontal)

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
                    .padding(.top, 8)
                }

                // Dismiss the search overlay
                if !searchText.isEmpty {
                    Color.black
                        .opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            searchText = ""
                            searchVM.results = []
                            //dismissKeyboard()
                        }
                        .zIndex(1)
                }

                if !searchText.isEmpty {
                    SearchResultsDropdown(
                        meals: searchVM.results,
                        query: searchText,
                        onSelect: { _ in
                            searchText = ""
                            searchVM.results = []
                            //dismissKeyboard()
                        }
                    )
                    .padding(.horizontal)
                    .padding(.top, 70)
                    .zIndex(2)
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

