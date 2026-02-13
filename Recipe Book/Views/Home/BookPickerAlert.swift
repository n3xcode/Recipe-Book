//
//  BookPickerAlert.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/13.
//

import SwiftUI

struct BookPickerAlert: View {

    @ObservedObject var vm: SavedBooksViewModel

    let onSelect: (BookEntity) -> Void
    let onBookCreated: () -> Void
    let onDismiss: () -> Void

    @State private var showAddBook = false
    @State private var newBookName = ""

    var body: some View {
        ZStack {

            // Background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }

            VStack(spacing: 20) {

                Text("Save To")
                    .font(.headline)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(vm.books, id: \.objectID) { book in
                            Button {
                                onSelect(book)
                            } label: {
                                HStack {
                                    Text(book.name ?? "Untitled")
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .frame(maxHeight: 300)

                Divider()

                Button {
                    showAddBook = true
                } label: {
                    Label("Add New Book", systemImage: "plus")
                }

                Button("Cancel") {
                    onDismiss()
                }
                .foregroundColor(.red)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .padding(.horizontal, 24)

            if showAddBook {
                CustomTextFieldAlert(
                    title: "New Book",
                    text: $newBookName,
                    confirmTitle: "Create",
                    onCancel: {
                        showAddBook = false
                    },
                    onConfirm: {
                        let trimmed = newBookName.trimmingCharacters(in: .whitespaces)
                        guard !trimmed.isEmpty else { return }

                        vm.addBook(name: trimmed)
                        vm.loadBooks()
                        onBookCreated()

                        newBookName = ""
                        showAddBook = false
                    }
                )
            }
        }
    }
}


