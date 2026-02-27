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
    
    init() {
        let memoryCapacity = 50 * 1024 * 1024   // 50 MB
        let diskCapacity = 200 * 1024 * 1024    // 200 MB

        URLCache.shared = URLCache(
            memoryCapacity: memoryCapacity,
            diskCapacity: diskCapacity
        )
    }

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
