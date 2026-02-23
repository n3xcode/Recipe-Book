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
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

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
        let bookIDString = book.id?.uuidString ?? ""
        
        // 1. Delete from Core Data (Cascade rule handles Recipe entities)
        context.delete(book)
        save()
        
        // 2. Wipe the entire folder for this book
        if !bookIDString.isEmpty {
            ImageStorageManager.shared.deleteBookFolder(bookID: bookIDString)
        }
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
