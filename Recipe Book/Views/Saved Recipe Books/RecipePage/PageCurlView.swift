//
//  PageCurlView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//

import SwiftUI
import UIKit

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
            let first = context.coordinator.controller(for: 0)
            controller.setViewControllers([first], direction: .forward, animated: false)
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        // No-op
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

        var parent: PageCurlView
        private var controllers: [Int: UIViewController] = [:]

        init(parent: PageCurlView) {
            self.parent = parent
        }

        func controller(for index: Int) -> UIViewController {
            if let existing = controllers[index] {
                return existing
            }

            let hosting = UIHostingController(
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

            guard let index = controllers.first(where: { $0.value == viewController })?.key,
                  index > 0 else { return nil }

            return controller(for: index - 1)
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController
        ) -> UIViewController? {

            guard let index = controllers.first(where: { $0.value == viewController })?.key,
                  index < parent.count - 1 else { return nil }

            return controller(for: index + 1)
        }

        // MARK: Delegate

        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool
        ) {
            guard completed,
                  let visible = pageViewController.viewControllers?.first,
                  let index = controllers.first(where: { $0.value == visible })?.key
            else { return }

            parent.currentIndex = index
        }
    }
}

