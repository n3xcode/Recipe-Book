//
//  ProfileHeaderView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//

import SwiftUI

struct ProfileHeaderView: View {

    let name: String
    let email: String

    var body: some View {
        HStack(spacing: 16) {

            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)

                Text(email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// link demo data with real user info later
struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(name: "Bob", email: "ya@yeet.com")
    }
}
