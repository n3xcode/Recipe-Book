//
//  MyRecipesView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

struct MyRecipesView: View {
    var body: some View {
        Text("My Recipes")
            .navigationBarTitle("My Recipes", displayMode: .large)
    }
}

struct MyRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MyRecipesView()
        }
    }
}

