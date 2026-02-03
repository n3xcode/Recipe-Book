//
//  AppEnvironment.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/21.
//

import SwiftUI


//MARK: User session
final class UserSession: ObservableObject {

    @Published var isSignedIn: Bool {
        didSet {
            UserDefaults.standard.set(isSignedIn, forKey: "isSignedIn")
        }
    }

    init() {
        self.isSignedIn = UserDefaults.standard.bool(forKey: "isSignedIn")
    }
}
