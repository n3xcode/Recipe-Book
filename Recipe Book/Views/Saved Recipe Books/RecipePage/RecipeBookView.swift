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
    @Environment(\.dismiss) private var dismiss

    init(book: BookEntity) {
        self.book = book
        _vm = StateObject(wrappedValue: RecipeBookViewModel(book: book))
    }

    var body: some View {
        ZStack {
            PageCurlView(
                count: vm.recipes.count,
                currentIndex: $vm.currentIndex
            ) { index in
                Group {
                    if let recipe = vm.recipe(at: index) {
                        RecipePageView(
                            recipe: recipe,
                            image: vm.image(for: index)
                        )
                    } else {
                        Color.clear
                    }
                }
            }
        }
        .navigationBarTitle(book.name ?? "Untitled", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        vm.deleteCurrentRecipe()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onChange(of: vm.recipes.count) { newCount in
            if newCount == 0 {
                dismiss()
            }
        }
        .ignoresSafeArea()
    }
}


//struct RecipeBookView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {)
//        }
//    }
//}
