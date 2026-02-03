//
//  SignInFormView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/02.
//

import SwiftUI

struct SignInFormView: View {
    @EnvironmentObject var session: UserSession
    @EnvironmentObject var settings: UserSettings

    @State private var username = ""
    @State private var email = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In")
                .font(.largeTitle.bold())

            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)

            Button("Continue") {
                settings.username = username
                settings.email = email
                session.isSignedIn = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}



struct SignInFormView_Previews: PreviewProvider {
    static var previews: some View {
        SignInFormView()
    }
}
