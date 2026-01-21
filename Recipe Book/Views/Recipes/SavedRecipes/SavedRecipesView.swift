//
//  SavedRecipesView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//
//add a default book if theres no place for a new recipe to be saved

import SwiftUI

struct SavedRecipesView: View {

    var body: some View {
        List {
            Section(header: Text("My Recipe Books")) {
                ForEach(0..<3, id: \.self) { index in

                    NavigationLink {
                        RecipeBookView(bookTitle: "Book \(index + 1)")
                    } label: {
                        RecipeBookRowView(
                            title: "Book \(index + 1)",
                            recipeCount: 5 + index
                        )
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {

                        // Edit Book link to book name later
                        Button {
                            print("Edit Book \(index + 1)")
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)

                        // Delete action
                        Button(role: .destructive) {
                            print("Delete Book \(index + 1)")
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("My Recipes", displayMode: .large)
    }
}

struct SavedRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SavedRecipesView()
        }
    }
}
