//
//  GuestUserView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/02.
//

import SwiftUI

struct GuestUserView: View {
    
    @EnvironmentObject var session: UserSession

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.crop.circle.badge.questionmark")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundStyle(.secondary)

            Text("Welcome, Guest")
                .font(.title.bold())

            Text("Sign in to save recipes, personalize your experience, and sync across devices.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            NavigationLink {
                SignInFormView()
            } label: {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
        }
        .padding()
    }
}


struct GuestUserView_Previews: PreviewProvider {
    static var previews: some View {
        GuestUserView()
    }
}
