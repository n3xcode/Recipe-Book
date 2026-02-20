//
//  HomePageRecipeView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/23.
//

import SwiftUI

struct HomePageRecipeView: View {
    
    let mealID: String
    
    // Dismiss action from the environment
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
                        
                    } else {
                        ProgressView("Loading recipe...")
                            .padding()
                    }
                }
                
                // MARK: - Custom Modal
                if showBookPicker {
                    BookPickerAlert(
                        vm: booksVM,
                        onSelect: { book in
                            selectedBook = book
                            handleSave(to: book)
                        },
                        onBookCreated: {
                            booksVM.loadBooks()
                        },
                        onDismiss: {
                            showBookPicker = false
                        }
                    )
                }
            }
            .navigationTitle("Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Bookmark button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showBookPicker = true
                    } label: {

                        Image(systemName: svImg.isBookmarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(svImg.isBookmarked ? .yellow : .primary)
                        
                    }
                }
                
                // Close button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .task {
                await vm.fetchRecipe(by: mealID)
                // Check if already bookmarked on load (might not do it, could discourage repeat saves over different books)
            }
            .alert(
                "Recipe already exists in this book. Save duplicate?",
                isPresented: $showDuplicateAlert
            ) {
                Button("Cancel", role: .cancel) {}
                
                Button("Save Anyway") {
                    guard let book = selectedBook,
                          let thumbnailURL = vm.recipe?.thumbnail,
                          let fileName = URL(string: thumbnailURL)?.lastPathComponent else {
                        return
                    }
                    
                    _ = saveCoordinator.handleSave(
                        vm: vm,
                        book: book,
                        thumbnailFileName: fileName,
                        allowDuplicate: true
                    )
                    
                    svImg.saveImageToDisk(getRecipeImgUrl: thumbnailURL)
                    
                    // UI FIX: Update state immediately
                    svImg.isBookmarked = true
                    
                    showBookPicker = false
                }
            }
        }
    }
    
    // MARK: - Save Handler
    private func handleSave(to book: BookEntity) {
        guard let thumbnailURL = vm.recipe?.thumbnail,
              let fileName = URL(string: thumbnailURL)?.lastPathComponent else {
            return
        }

        let result = saveCoordinator.handleSave(
            vm: vm,
            book: book,
            thumbnailFileName: fileName,
            allowDuplicate: false
        )

        switch result {
        case .duplicateFound:
            showDuplicateAlert = true
            
        case .success:
            svImg.saveImageToDisk(getRecipeImgUrl: thumbnailURL)
            
            // UI FIX: Force the icon to fill immediately
            svImg.isBookmarked = true
            
            showBookPicker = false
            
        case .failed:
            // add an error if needed
            break
        }
    }
}





struct HomePageRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageRecipeView(mealID: "52949")
    }
}
