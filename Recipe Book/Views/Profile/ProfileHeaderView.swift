//
//  ProfileHeaderView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    @StateObject private var vm = AvatarPickerViewModel()
    @State private var showingAvatarPicker = false
    @State private var tempSelectedAvatar: Avatar?
    
    let name: String
    let email: String
    
    var body: some View {
            VStack(alignment: .leading, spacing: 12) {

                // MARK: - Avatar + Info
                HStack(spacing: 16) {
                    // Profile picture tappable
                    Image(vm.selectedAvatar.rawValue)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        .onTapGesture {
                            // Open avatar picker sheet
                            tempSelectedAvatar = vm.selectedAvatar
                            showingAvatarPicker = true
                        }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(name)
                            .font(.headline)

                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            // MARK: - Avatar Picker Sheet
            .sheet(isPresented: $showingAvatarPicker) {
                NavigationView {
                    VStack {
                        Text("Choose Your Avatar")
                            .font(.headline)
                            .padding(.top)

                        Spacer()

                        // Show avatars in grid
                        let columns = [GridItem(.adaptive(minimum: 80), spacing: 16)]
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(vm.avatars) { avatar in
                                Image(avatar.rawValue)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(tempSelectedAvatar == avatar ? Color.blue : Color.clear, lineWidth: 3)
                                    )
                                    .onTapGesture {
                                        tempSelectedAvatar = avatar
                                    }
                            }
                        }
                        .padding()

                        Spacer()
                    }
                    .navigationBarItems(
                        leading: Button("Cancel") {
                            showingAvatarPicker = false
                        },
                        trailing: Button("Done") {
                            if let selected = tempSelectedAvatar {
                                vm.select(selected)
                            }
                            showingAvatarPicker = false
                        }
                    )
                }
            }
        }
    }


// link demo data with real user info later
struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(name: "Bob", email: "ya@yeet.com")
    }
}
