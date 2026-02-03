//
//  PageCurlView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//

import SwiftUI
import UIKit

struct PageCurlView<Page: View>: UIViewControllerRepresentable {

    let pages: [Page]

    func makeUIViewController(context: Context) -> UIPageViewController {

        let controller = UIPageViewController(
            transitionStyle: .pageCurl,
            navigationOrientation: .horizontal,
            options: nil
        )

        controller.dataSource = context.coordinator

        if let first = context.coordinator.controllers.first {
            controller.setViewControllers(
                [first],
                direction: .forward,
                animated: false
            )
        }

        return controller
    }

    func updateUIViewController(
        _ uiViewController: UIPageViewController,
        context: Context
    ) {
        // No-op for now
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(pages: pages)
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, UIPageViewControllerDataSource {

        let controllers: [UIViewController]

        init(pages: [Page]) {
            self.controllers = pages.map {
                UIHostingController(rootView: $0)
            }
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController
        ) -> UIViewController? {
            guard
                let index = controllers.firstIndex(of: viewController),
                index > 0
            else { return nil }

            return controllers[index - 1]
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController
        ) -> UIViewController? {
            guard
                let index = controllers.firstIndex(of: viewController),
                index < controllers.count - 1
            else { return nil }

            return controllers[index + 1]
        }
    }
}
