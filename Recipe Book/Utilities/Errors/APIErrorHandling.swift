//
//  APIErrorHandling.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/03.
//

import Foundation

// MARK: Search Error Handling
enum SearchError: Error {
    case cancelled
    case networkError(URLError)
    case decodingError(DecodingError)
    case unknownError(Error)
    
    var localizedDescription: String {
        switch self {
        case .cancelled:
            return "Search was cancelled due to new input."
        case .networkError(let error):
            // Here we provide more detailed logging for network errors
            if let nsError = error as NSError? {
                let failedURL = nsError.userInfo["NSErrorFailingURLStringKey"] as? String ?? "Unknown URL"
                return "Network error occurred: \(error.localizedDescription), URL: \(failedURL)"
            }
            return "Network error occurred: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error occurred while processing meals response: \(error.localizedDescription) or no matching items"
        case .unknownError(let error):
            return "Search failed with unexpected error: \(error.localizedDescription)"
        }
    }
}

// Centralized error logging method
func handleError(_ error: SearchError) {
    print(error.localizedDescription)
}
