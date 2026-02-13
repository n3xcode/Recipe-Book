//
//  BookRepository.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/12.
//

import CoreData

final class BookRepository: ObservableObject {

    private let context = CoreDataManager.shared.context

    // Fetch all books
    func fetchBooks() -> [BookEntity] {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }

    // Create book
    func createBook(name: String) {
        let book = BookEntity(context: context)
        book.id = UUID()
        book.name = name
        book.date = Date()

        save()
    }

    // Update book
    func updateBook(_ book: BookEntity, newName: String) {
        book.name = newName
        save()
    }

    // Delete book
    func deleteBook(_ book: BookEntity) {
        context.delete(book)
        save()
    }

    private func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }
}
