//
//  MealSearch.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/03.
//

import Foundation
import UIKit

@MainActor
final class MealSearchViewModel: ObservableObject {
    
    @Published var query: String = ""
    @Published var results: [HomeMealPage] = []
    private let imageCache = NSCache<NSString, UIImage>()
    
    private let api: MealAPI
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

        searchTask = Task {
            do {
                // debouncing = 350ms
                try await Task.sleep(nanoseconds: 350_000_000)

                guard !Task.isCancelled else {
                    throw SearchError.cancelled
                }

                let meals = try await api.fetchMeals(from: .search(trimmed))

                let mapped = meals
                    .map { $0.summary }
                    .prefix(10)
                    .map { $0 }

                self.results = mapped

                await preloadThumbnails(for: mapped)
                
            } catch is CancellationError {
                handleError(.cancelled)
            } catch let error as URLError {
                // network error
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
    
    private func preloadThumbnails(for meals: [HomeMealPage]) async {
        await withTaskGroup(of: Void.self) { group in
            for meal in meals {
                guard
                    meal.id != "no_results",
                    SearchImageCache.shared.image(for: meal.thumbnail) == nil,
                    let url = URL(string: meal.thumbnail)
                else { continue }

                group.addTask {
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        if let image = UIImage(data: data) {
                            SearchImageCache.shared.insert(image, for: meal.thumbnail)
                        }
                    } catch {
                        // ignore
                    }
                }
            }
        }
    }

}

final class SearchImageCache {

    static let shared = SearchImageCache()

    private let cache = NSCache<NSString, UIImage>()

    func image(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func insert(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func clear() {
        cache.removeAllObjects()
    }
}

final class ImageLoader: ObservableObject {

    @Published var image: UIImage?

    private let url: URL?

    init(url: URL?) {
        self.url = url
        load()
    }

    private func load() {
        guard let url else { return }

        // Check URLCache first
        let request = URLRequest(
            url: url,
            cachePolicy: .returnCacheDataElseLoad,
            timeoutInterval: 30
        )

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                if let img = UIImage(data: data) {
                    await MainActor.run {
                        self.image = img
                    }
                }
            } catch {
                // silent fail
            }
        }
    }
}

