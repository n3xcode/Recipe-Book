//
//  BasicErrorHandling.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/27.
//

import Foundation

enum RecipeError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
