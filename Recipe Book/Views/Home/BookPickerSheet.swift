//
//  BookPickerSheet.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/13.
//

import SwiftUI

struct BookPickerSheet: View {

    @ObservedObject var vm: SavedBooksViewModel
    let onSelect: (BookEntity) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var showAddBook = false
    @State private var newBookName = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Select Book") {
                    ForEach(vm.books, id: \.objectID) { book in
                        Button(book.name ?? "Untitled") {
                            onSelect(book)
                            dismiss()
                        }
                    }
                }

                Section {
                    Button {
                        showAddBook = true
                    } label: {
                        Label("Add New Book", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Save To")
            .alert("New Book", isPresented: $showAddBook) {
                TextField("Book Name", text: $newBookName)
                Button("Cancel", role: .cancel) {}
                Button("Create") {
                    vm.addBook(name: newBookName)
                }
            }
        }
    }
}


//struct BookPickerSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        BookPickerSheet()
//    }
//}
