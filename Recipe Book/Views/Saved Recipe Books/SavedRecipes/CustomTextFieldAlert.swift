//
//  CustomTextFieldAlert.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/12.
//

import SwiftUI

struct CustomTextFieldAlert: View {

    let title: String
    @Binding var text: String
    let confirmTitle: String
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        ZStack {
            // Background blur
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .transition(.opacity)

            VStack(spacing: 16) {

                Text(title)
                    .font(.headline)

                TextField("Book Name", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Divider()

                HStack(spacing: 0) {

                    Button("Cancel") {
                        onCancel()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.red)

                    Divider()

                    Button(confirmTitle) {
                        onConfirm()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .fontWeight(.semibold)
                }
                .frame(height: 44)
            }
            .padding(.top, 20)
            .frame(width: 300)
            .background(.regularMaterial)
            .cornerRadius(14)
            .shadow(radius: 20)
            .transition(.scale)
        }
        .animation(.easeInOut(duration: 0.2), value: text)
    }
}

