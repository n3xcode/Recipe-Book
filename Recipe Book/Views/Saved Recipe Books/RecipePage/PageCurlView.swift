//
//  PageCurlView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//

import SwiftUI
import UIKit

// custom controller that permanently stores its index
class IndexedHostingController<Content: View>: UIHostingController<Content> {
    let pageIndex: Int
    
    init(pageIndex: Int, rootView: Content) {
        self.pageIndex = pageIndex
        super.init(rootView: rootView)
        self.view.backgroundColor = .systemBackground
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct PageCurlView<Page: View>: UIViewControllerRepresentable {

    let count: Int
    @Binding var currentIndex: Int
    let content: (Int) -> Page

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        
        let controller = UIPageViewController(
            transitionStyle: .pageCurl,
            navigationOrientation: .horizontal,
            options: nil
        )

        controller.dataSource = context.coordinator
        controller.delegate = context.coordinator

        if count > 0 {
            let safeIndex = max(0, min(currentIndex, count - 1))
            let first = context.coordinator.controller(for: safeIndex)
            controller.setViewControllers([first], direction: .forward, animated: false)
        }
        controller.view.backgroundColor = .systemBackground
        controller.isDoubleSided = false

        return controller
    }

    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        guard count > 0 else { return }

        let safeIndex = max(0, min(currentIndex, count - 1))
        let visibleVC = uiViewController.viewControllers?.first as? IndexedHostingController<Page>

        // Only update if index really changed
        guard visibleVC?.pageIndex != safeIndex else { return }

        let currentVC = context.coordinator.controller(for: safeIndex)

        // Use the safe method to handle transitions
        context.coordinator.setViewControllerSafely(uiViewController, to: safeIndex)

        // Clean up controllers that are out of bounds
        let keysToRemove = context.coordinator.controllers.keys.filter { $0 >= count }
        for key in keysToRemove { context.coordinator.controllers.removeValue(forKey: key) }
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

        var parent: PageCurlView
        var controllers: [Int: IndexedHostingController<Page>] = [:]

        // lock to prevent overlapping transitions
        private var isTransitioning = false
        private var pendingIndex: Int? = nil

        init(parent: PageCurlView) {
            self.parent = parent
        }

        // MARK: - Controller management
        func controller(for index: Int) -> IndexedHostingController<Page> {
            guard index >= 0 && index < parent.count else {
                fatalError("Invalid page index: \(index)")
            }

            if let existing = controllers[index] {
                // Always refresh content in case data changed
                existing.rootView = parent.content(index)
                return existing
            }

            let hosting = IndexedHostingController(
                pageIndex: index,
                rootView: parent.content(index)
            )
            controllers[index] = hosting
            return hosting
        }

        // MARK: - UIPageViewController DataSource
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController
        ) -> UIViewController? {
            guard let currentVC = viewController as? IndexedHostingController<Page> else { return nil }
            let index = currentVC.pageIndex
            guard index > 0 else { return nil }
            return controller(for: index - 1)
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController
        ) -> UIViewController? {
            guard let currentVC = viewController as? IndexedHostingController<Page> else { return nil }
            let index = currentVC.pageIndex
            let nextIndex = index + 1
            guard nextIndex >= 0 && nextIndex < parent.count else { return nil }
            return controller(for: nextIndex)
        }

        // MARK: - UIPageViewController Delegate
        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool
        ) {
            guard completed,
                  let visible = pageViewController.viewControllers?.first as? IndexedHostingController<Page> else { return }

            // Release transition lock
            isTransitioning = false

            // Update SwiftUI state
            DispatchQueue.main.async {
                self.parent.currentIndex = visible.pageIndex
            }

            // Apply any pending page request
            if let pending = pendingIndex, pending != visible.pageIndex {
                pendingIndex = nil
                setViewControllerSafely(pageViewController, to: pending)
            }

            // Cleanup controllers out of bounds
            let keysToRemove = controllers.keys.filter { $0 >= parent.count }
            for key in keysToRemove { controllers.removeValue(forKey: key) }
        }

        // MARK: - Safe programmatic page setter
        func setViewControllerSafely(_ pageVC: UIPageViewController, to index: Int) {
            guard index >= 0 && index < parent.count else { return }

            guard let visibleVC = pageVC.viewControllers?.first as? IndexedHostingController<Page> else { return }
            if visibleVC.pageIndex == index { return } // Already on desired page

            if isTransitioning {
                // Save latest request to apply after current transition
                pendingIndex = index
                return
            }

            isTransitioning = true

            let currentVC = controller(for: index)
            let direction: UIPageViewController.NavigationDirection =
                (visibleVC.pageIndex < index) ? .forward : .reverse

            // Dispatch async to avoid overlapping run loop calls
            DispatchQueue.main.async {
                pageVC.setViewControllers([currentVC], direction: direction, animated: true)
            }
        }
    }
}

