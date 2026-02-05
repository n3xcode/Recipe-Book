//
//  MealSearch.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/03.
//

import Foundation

@MainActor
final class MealSearchViewModel: ObservableObject {
    
    @Published var query: String = ""
    @Published var results: [HomeMealPage] = []
    
    private let api: MealAPI   // whatever type `api.fetchMeals` belongs to
    private var searchTask: Task<Void, Never>?
    
    init(api: MealAPI) {
        self.api = api
    }
    
    func onQueryChange(_ newValue: String) {
        // Cancel the previous search task if it exists
        searchTask?.cancel()

        // Trim the input value to avoid unnecessary spaces
        let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)

        // If the input is empty, clear the results
        guard !trimmed.isEmpty else {
            results = []
            return
        }

        // Create a new task for the search
        searchTask = Task {
            do {
                // Add debouncing by delaying the request for 350ms
                try await Task.sleep(nanoseconds: 350_000_000)

                // If the task was cancelled during the sleep, exit early
                guard !Task.isCancelled else {
                    throw SearchError.cancelled
                }

                // Perform the network request
                let meals = try await api.fetchMeals(from: .search(trimmed))

                // Update the results, ensuring that we map only the top 5
                self.results = meals
                    .map { $0.summary }
                    .prefix(5)
                    .map { $0 }
                
            } catch is CancellationError {
                // Throw a cancellation error with specific case
                handleError(.cancelled)
            } catch let error as URLError {
                // Throw a network error with the specific URLError
                handleError(.networkError(error))
            } catch let error as DecodingError {
                // Handle decoding errors
                handleError(.decodingError(error))
                //UI toggtle if theres no results
                self.results = [.noResults]
            } catch {
                // Handle unexpected errors
                handleError(.unknownError(error))
            }
        }
    }

}
