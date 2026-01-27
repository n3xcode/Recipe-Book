//
//  HomeMealTile.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/23.
//

import Foundation

struct HomeMealTile: Identifiable {
    let id = UUID()
    let title: String
    let thumbnail: String   // image name or URL later
    let subtitle: String       //
}
