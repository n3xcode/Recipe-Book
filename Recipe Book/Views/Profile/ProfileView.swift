//
//  ProfileView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        Text("Profile")
            .navigationBarTitle("Profile", displayMode: .large)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}
