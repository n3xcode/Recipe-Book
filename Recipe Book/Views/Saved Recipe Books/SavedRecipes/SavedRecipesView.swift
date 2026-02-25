//
//  SavedRecipesView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//
//add a default book if theres no place for a new recipe to be saved

import SwiftUI

struct SavedRecipesView: View {

    //@StateObject private var vm = SavedBooksViewModel()
    @Environment(\.managedObjectContext) private var context

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BookEntity.date, ascending: true)],
        animation: .default
    )
    private var books: FetchedResults<BookEntity>

    @State private var showAddAlert = false
    @State private var showEditAlert = false
    @State private var newBookName = ""
    @State private var selectedBook: BookEntity?

    var body: some View {
        ZStack {
            List {
                Section(header: Text("My Recipe Books")) {

                    ForEach(books) { book in

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
                                context.delete(book)
                                try? context.save()
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
//            .onAppear {
//                vm.loadBooks()
//            }
            
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

                        let book = BookEntity(context: context)
                        book.id = UUID()
                        book.name = trimmed
                        book.date = Date()

                        try? context.save()
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
                            selectedBook.name = newBookName
                            try? context.save()
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
