//
//  RootView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var session = UserSession()
    @StateObject private var settings = UserSettings.shared
    
    var body: some View {
        TabView {

            NavigationView {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationView {
                SavedRecipesView()
            }
            .tabItem {
                Label("My Recipes", systemImage: "book.fill")
            }

            NavigationView {
                if session.isSignedIn {
                    ProfileView()
                } else {
                    GuestUserView()
                }
            }
            .environmentObject(settings)
            .environmentObject(session)
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
