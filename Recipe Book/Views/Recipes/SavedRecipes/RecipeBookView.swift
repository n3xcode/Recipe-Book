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
        TabView {
            ForEach(0..<6, id: \.self) { index in
                RecipePageView(recipeIndex: index)
                    .padding(.horizontal)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .navigationBarTitle(bookTitle, displayMode: .inline)
    }
}

struct RecipeBookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeBookView(bookTitle: "My Favorites")
        }
    }
}
