//
//  RecipeBookView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//

import SwiftUI

struct RecipeBookView: View {

    let bookTitle: String

    var body: some View {
        PageCurlView(
            pages: (0..<5).map { index in
                RecipePageView(recipeIndex: index)
            }
        )
        .navigationBarTitle(bookTitle, displayMode: .inline)
        .ignoresSafeArea()
    }
}

struct RecipeBookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeBookView(bookTitle: "My Favorites")
        }
    }
}
