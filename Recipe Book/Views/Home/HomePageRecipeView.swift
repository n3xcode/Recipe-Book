//
//  HomePageRecipeView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/23.
//

import SwiftUI

struct HomePageRecipeView: View {

    let query: String

    var body: some View {
        VStack {
            Text("Recipes for")
                .font(.headline)

            Text(query.capitalized)
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer()
        }
        .padding()
        .navigationTitle(query.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct HomePageRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageRecipeView(query: "chicken")
    }
}
