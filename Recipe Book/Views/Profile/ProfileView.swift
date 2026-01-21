//
//  ProfileView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

struct ProfileView: View {

    //@EnvironmentObject var env: AppEnvironment
    
    // TEMP state placeholders
    @State private var dietaryPreferences = DietaryPreferenceOptions.none
    @State private var useMetricUnits = true
    @State private var showNutrition = true
    @State private var isPremiumUser = true

    var body: some View {
        List {


               // MARK: - Profile Header
               Section {
                   ProfileHeaderView(
                       name: "Bob A.",
                       email: "test@email.com"
                   )
               }
            
            
            // MARK: - Premium Upgrade
               Section {
                   PremiumUpgradeView()
                       .listRowInsets(EdgeInsets())
               }

            // MARK: - Dietary Preferences
            Section(header: Text("Diet Preferences")) {

                VStack(alignment: .leading, spacing: 6) {

                    Picker("Diet Type", selection: $dietaryPreferences) {
                        ForEach(DietaryPreferenceOptions.allCases, id: \.self) { option in
                            Text(option.title)
                        }
                    }
                    .disabled(!isPremiumUser)
                    .opacity(isPremiumUser ? 1.0 : 0.5)

                    if !isPremiumUser {
                        Text("Unlock diet-based recipe filtering with Premium.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            // MARK: - Cooking Preferences
            Section(header: Text("Cooking")) {

                Toggle("Use Metric Units", isOn: $useMetricUnits)

                Toggle("Show Nutrition Info", isOn: $showNutrition)

            }

            // MARK: - Account
            Section(header: Text("Account")) {

                Button {
                    print("Sign Out")
                } label: {
                    Text("Sign Out")
                }

                Button(role: .destructive) {
                    print("Delete Account")
                } label: {
                    Text("Delete Account")
                }
            }

            // MARK: - App Info
            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
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
