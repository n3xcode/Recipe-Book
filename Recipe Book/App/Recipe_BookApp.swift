//
//  Recipe_BookApp.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

@main
struct Recipe_BookApp: App {

    let persistenceController = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(
                    \.managedObjectContext,
                    persistenceController.context
                )
        }
    }
}
