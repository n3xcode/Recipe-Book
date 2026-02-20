//
//  HomePageRecipeView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/23.
//

import SwiftUI

struct HomePageRecipeView: View {
    let mealID: String
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var vm = RecipeDetailViewModel()
    @StateObject private var svImg = SaveRecipeImg()
    @StateObject private var booksVM = SavedBooksViewModel()
    
    @State private var showBookPicker = false
    @State private var showDuplicateAlert = false
    @State private var selectedBook: BookEntity?
    
    private let saveCoordinator = SaveRecipeCoordinator()
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    if let recipe = vm.recipe {
                        recipeContent(recipe)
                    } else {
                        ProgressView("Loading recipe...").padding()
                    }
                }

                if showBookPicker {
                    BookPickerAlert(
                        vm: booksVM,
                        onSelect: { book in
                            selectedBook = book
                            performSave(to: book, allowDuplicate: false)
                        },
                        onBookCreated: { booksVM.loadBooks() },
                        onDismiss: { showBookPicker = false }
                    )
                }
            }
            .navigationTitle("Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showBookPicker = true
                    } label: {
                        Image(systemName: svImg.isBookmarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(svImg.isBookmarked ? .yellow : .primary)
                            // Remove the .contentTransition line
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .task {
                await vm.fetchRecipe(by: mealID)
                svImg.checkIfBookmarked(mealID: mealID)
            }
            .alert("Recipe already exists in this book. Save duplicate?", isPresented: $showDuplicateAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Save Anyway") {
                    if let book = selectedBook {
                        performSave(to: book, allowDuplicate: true)
                    }
                }
            }
        }
    }

    // UPDATED: Now handles the async call from the Coordinator
    private func performSave(to book: BookEntity, allowDuplicate: Bool) {
        Task {
            let result = await saveCoordinator.handleSave(
                vm: vm,
                book: book,
                saveImgVM: svImg,
                allowDuplicate: allowDuplicate
            )
            
            await MainActor.run {
                if result == .duplicateFound {
                    showDuplicateAlert = true
                } else if result == .success {
                    withAnimation(.spring()) {
                        showBookPicker = false
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func recipeContent(_ recipe: SelectedMealPage) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(recipe.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            AsyncImage(url: URL(string: recipe.thumbnail)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(height: 200)
            .cornerRadius(12)
            .clipped()
            
            Text("Ingredients")
                .font(.title2)
                .fontWeight(.semibold)
            
            ForEach(recipe.ingredients.indices, id: \.self) { index in
                let ingredient = recipe.ingredients[index]
                Text("• \(ingredient.measure) \(ingredient.name)")
            }
            
            Divider()
            
            Text("Instructions")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(recipe.instructions)
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .padding()
    }
}



struct HomePageRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageRecipeView(mealID: "52949")
    }
}
