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
        searchTask?.cancel()

        let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            results = []
            return
        }

        searchTask = Task {
            // debounce
            try? await Task.sleep(nanoseconds: 350_000_000)

            guard !Task.isCancelled else { return }

            do {
                let meals = try await api.fetchMeals(from: .search(trimmed))
                self.results = meals
                    .map { $0.summary }
                    .prefix(5)
                    .map { $0 }
            } catch is CancellationError {
                // ignore
            } catch {
                print("Search failed:", error)
                self.results = []
            }
        }
    }
}
