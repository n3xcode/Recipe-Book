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

    @StateObject private var nav = HomeNavigationState()
    
    @State private var searchText: String = ""

    private var isOverlayActive: Bool {
        !searchText.isEmpty
    }

    init() {
        let api = MealAPI()
        _vm = StateObject(wrappedValue: HomePageRecipeViewModel(api: api))
        _searchVM = StateObject(wrappedValue: MealSearchViewModel(api: api))
    }

    var body: some View {
        ZStack(alignment: .top) {

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

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
                            GridItem(.flexible(), spacing: 20),
                            GridItem(.flexible(), spacing: 20)
                        ],
                        spacing: 35
                    ) {
                        ForEach(vm.homeMeals) { meal in
                            Button {
                                // Use the new nav class
                                nav.showMeal(id: meal.id)
                            } label: {
                                RecipeTileView(
                                    title: meal.title,
                                    subtitle: meal.area,
                                    imageName: meal.thumbnail
                                )
                            }
                            .buttonStyle(.plain)
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

            // Overlay for dismissal
            if !searchText.isEmpty {
                Color.black
                    .opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        searchText = ""
                        searchVM.results = []
                    }
                    .zIndex(1)
            }

            // Search Results Dropdown
            if !searchText.isEmpty {
                SearchResultsDropdown(
                    meals: searchVM.results,
                    query: searchText,
                    onSelect: { meal in
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                        // links sheet via our nav class
                        nav.showMeal(id: meal.id)
                        
                        self.searchText = ""
                        self.searchVM.results = []
                    }
                )
                .padding(.horizontal)
                .padding(.top, 70)
                .zIndex(2)
            }
        }
        .navigationTitle("Home")
        .sheet(item: $nav.selectedMeal) { item in
            HomePageRecipeView(mealID: item.id)
        }
        .refreshable {
            if !isOverlayActive {
                await vm.refreshHomeMeals()
            }
        }
        .task {
            await vm.loadHomeMealsIfNeeded()
        }
    }
}





struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

