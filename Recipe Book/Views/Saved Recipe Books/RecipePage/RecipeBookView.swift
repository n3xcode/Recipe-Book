//
//  RecipeBookView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//

import SwiftUI

struct RecipeBookView: View {

    let book: BookEntity
    @Environment(\.managedObjectContext) private var context

    @FetchRequest var recipes: FetchedResults<RecipeEntity>
    @StateObject private var imageLoader = ImageWindowLoader()

    @State private var currentIndex = 0
    @Environment(\.dismiss) private var dismiss

    init(book: BookEntity) {
        self.book = book

        _recipes = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \RecipeEntity.date, ascending: true)],
            predicate: NSPredicate(format: "book == %@", book),
            animation: .default
        )
    }

    var body: some View {
        ZStack {
            PageCurlView(
                count: recipes.count,
                currentIndex: $currentIndex
            ) { index in
                AnyView(
                    Group {
                        if recipes.indices.contains(index) {
                            RecipePageView(
                                recipe: recipes[index],
                                image: imageLoader.image(for: index)
                            )
                        } else {
                            Color.clear
                        }
                    }
                )
            }
        }
        .onAppear {
            updateImageWindow()
        }
        .onChange(of: currentIndex) { _ in
            updateImageWindow()
        }
        .onChange(of: recipes.count) { _ in
            updateImageWindow()
        }
        .navigationBarTitle(book.name ?? "Untitled", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        let recipe = recipes[currentIndex]
                        context.delete(recipe)
                        try? context.save()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onChange(of: recipes.count) { newCount in
            if newCount == 0 {
                dismiss()
            }
        }
        .ignoresSafeArea()
    }
    private func updateImageWindow() {
        guard recipes.count > 0 else { return }

        let lower = max(currentIndex - 1, 0)
        let upper = min(currentIndex + 1, recipes.count - 1)

        imageLoader.updateWindow(
            range: lower...upper,
            recipes: Array(recipes)
        )
    }
}


//struct RecipeBookView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {)
//        }
//    }
//}
