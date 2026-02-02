//
//  UserProfile.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/02.
//

import Foundation

enum Avatar: String, CaseIterable, Identifiable {
    case ProfilePicture1
    case ProfilePicture2
    case ProfilePicture3
    case ProfilePicture4
    case ProfilePicture5
    case ProfilePicture6

    var id: String { rawValue }
}

final class AvatarPickerViewModel: ObservableObject {

    private let storageKey = "selectedAvatar"

    @Published var selectedAvatar: Avatar {
        didSet {
            UserDefaults.standard.set(selectedAvatar.rawValue, forKey: storageKey)
        }
    }

    let avatars = Avatar.allCases

    init() {
        let saved = UserDefaults.standard.string(forKey: storageKey)
        self.selectedAvatar = Avatar(rawValue: saved ?? "") ?? .ProfilePicture1
    }

    func select(_ avatar: Avatar) {
        selectedAvatar = avatar
    }
}

