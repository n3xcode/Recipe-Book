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

        // If count changed (deletion), wipe cached controllers
        if context.coordinator.controllers.count != count {
            context.coordinator.controllers.removeAll()
        }

        let safeIndex = max(0, min(currentIndex, count - 1))
        let visibleVC = uiViewController.viewControllers?.first as? IndexedHostingController<Page>

        if visibleVC?.pageIndex != safeIndex {
            let currentVC = context.coordinator.controller(for: safeIndex)

            let direction: UIPageViewController.NavigationDirection =
                (visibleVC?.pageIndex ?? -1) < safeIndex ? .forward : .reverse

            uiViewController.setViewControllers([currentVC], direction: direction, animated: true)
        }
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

        var parent: PageCurlView
        var controllers: [Int: IndexedHostingController<Page>] = [:]

        init(parent: PageCurlView) {
            self.parent = parent
        }

        func controller(for index: Int) -> IndexedHostingController<Page> {

            // Hard guard against invalid indexes
            guard index >= 0 && index < parent.count else {
                fatalError("Attempted to access invalid page index: \(index)")
            }

            if let existing = controllers[index] {
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

        // MARK: DataSource

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController
        ) -> UIViewController? {
            
            guard let currentVC = viewController as? IndexedHostingController<Page> else { return nil }
            
            let index = currentVC.pageIndex
            guard index > 0 else { return nil } // Correctly stops user from going past index 0

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

        // MARK: Delegate

        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool
        ) {
            guard completed,
                  let visible = pageViewController.viewControllers?.first as? IndexedHostingController<Page>
            else { return }

            // Update SwiftUI state asynchronously to avoid UI warnings
            DispatchQueue.main.async {
                self.parent.currentIndex = visible.pageIndex
            }
        }
    }
}

