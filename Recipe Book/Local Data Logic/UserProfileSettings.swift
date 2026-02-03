//
//  UserProfileSettings.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/02.
//

import Foundation


// MARK: User Profile Picture
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


// MARK: User Profile Settings
final class UserSettings: ObservableObject {

    static let shared = UserSettings()
    private let defaults = UserDefaults.standard

    @Published var username: String {
        didSet { defaults.set(username, forKey: UserSettingsKey.username.rawValue) }
    }

    @Published var email: String {
        didSet { defaults.set(email, forKey: UserSettingsKey.email.rawValue) }
    }

    @Published var isPremium: Bool {
        didSet { defaults.set(isPremium, forKey: UserSettingsKey.isPremium.rawValue) }
    }

    private init() {
        self.username = defaults.string(forKey: UserSettingsKey.username.rawValue) ?? ""
        self.email = defaults.string(forKey: UserSettingsKey.email.rawValue) ?? ""
        self.isPremium = defaults.bool(forKey: UserSettingsKey.isPremium.rawValue)
    }

    // Explicit reload if needed later
    func load() {
        username = defaults.string(forKey: UserSettingsKey.username.rawValue) ?? ""
        email = defaults.string(forKey: UserSettingsKey.email.rawValue) ?? ""
        isPremium = defaults.bool(forKey: UserSettingsKey.isPremium.rawValue)
    }
}


extension UserDefaults {
    func value<T>(for key: UserSettingsKey) -> T? {
        object(forKey: key.rawValue) as? T
    }
}

