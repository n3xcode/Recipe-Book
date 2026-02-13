//
//  SavedBooksViewModel.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/12.
//

import CoreData

final class SavedBooksViewModel: ObservableObject {

    @Published var books: [BookEntity] = []

    private let repository = BookRepository()

    init() {
        loadBooks()
    }

    func loadBooks() {
        books = repository.fetchBooks()
    }

    func addBook(name: String) {
        repository.createBook(name: name)
        loadBooks()
    }

    func updateBook(_ book: BookEntity, name: String) {
        repository.updateBook(book, newName: name)
        loadBooks()
    }

    func deleteBook(_ book: BookEntity) {
        repository.deleteBook(book)
        loadBooks()
    }
}
