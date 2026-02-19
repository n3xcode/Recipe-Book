//
//  RecipeBookView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//

import SwiftUI

struct RecipeBookView: View {

    let book: BookEntity
    @StateObject private var vm: RecipeBookViewModel

    init(book: BookEntity) {
        self.book = book
        _vm = StateObject(wrappedValue: RecipeBookViewModel(book: book))
    }

    var body: some View {
        PageCurlView(
            count: vm.recipes.count,
            currentIndex: Binding(
                get: { vm.currentIndex },
                set: { vm.currentIndex = $0 }
            )
        ) { index in
            RecipePageView(
                recipe: vm.recipe(at: index),
                image: vm.image(for: index)
            )
        }
        .navigationBarTitle(book.name ?? "Untitled", displayMode: .inline)
        .ignoresSafeArea()
    }
}


//struct RecipeBookView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {)
//        }
//    }
//}
