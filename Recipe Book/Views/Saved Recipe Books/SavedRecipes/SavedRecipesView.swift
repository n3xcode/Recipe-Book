//
//  SavedRecipesView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//
//add a default book if theres no place for a new recipe to be saved

import SwiftUI

struct SavedRecipesView: View {

    @StateObject private var vm = SavedBooksViewModel()

    @State private var showAddAlert = false
    @State private var showEditAlert = false
    @State private var newBookName = ""
    @State private var selectedBook: BookEntity?

    var body: some View {
        ZStack {
            List {
                Section(header: Text("My Recipe Books")) {

                    ForEach(vm.books, id: \.objectID) { book in

                        NavigationLink {
                            RecipeBookView(book: book)
                        } label: {
                            RecipeBookRowView(
                                title: book.name ?? "Untitled",
                                recipeCount: book.recipe?.count ?? 0
                            )
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {

                            // Edit
                            Button {
                                selectedBook = book
                                newBookName = book.name ?? ""
                                showEditAlert = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)

                            // Delete
                            Button(role: .destructive) {
                                vm.deleteBook(book)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("My Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        newBookName = ""
                        showAddAlert = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                vm.loadBooks()
            }
            
            // MARK: - Add Book Alert
            if showAddAlert {
                CustomTextFieldAlert(
                    title: "New Book",
                    text: $newBookName,
                    confirmTitle: "Save",
                    onCancel: {
                        showAddAlert = false
                    },
                    onConfirm: {
                        let trimmed = newBookName.trimmingCharacters(in: .whitespaces)
                        guard !trimmed.isEmpty else { return }
                        vm.addBook(name: trimmed)
                        showAddAlert = false
                    }
                )
            }

            // MARK: - Edit Book Alert
            if showEditAlert {
                CustomTextFieldAlert(
                    title: "Edit Book",
                    text: $newBookName,
                    confirmTitle: "Update",
                    onCancel: {
                        showEditAlert = false
                    },
                    onConfirm: {
                        if let selectedBook {
                            vm.updateBook(selectedBook, name: newBookName)
                        }
                        showEditAlert = false
                    }
                )
            }
        }
    }
}


struct SavedRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SavedRecipesView()
        }
    }
}
