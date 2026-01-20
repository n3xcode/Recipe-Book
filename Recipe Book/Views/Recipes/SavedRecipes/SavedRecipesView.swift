//
//  SavedRecipesView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//

import SwiftUI

struct SavedRecipesView: View {

    var body: some View {
        List {
            Section(header: Text("My Recipe Books")) {
                ForEach(0..<3, id: \.self) { index in
                    NavigationLink {
                        RecipeBookView(bookTitle: "Book \(index + 1)")
                    } label: {
                        RecipeBookRowView(title: "Book \(index + 1)",
                                          recipeCount: 5 + index)
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
