//
//  HomeNavigationStack.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/20.
//

import Foundation
import SwiftUI

class HomeNavigationState: ObservableObject {

    struct SelectedMeal: Identifiable {
        let id: String
    }

    @Published var selectedMeal: SelectedMeal? = nil

    func showMeal(id: String) {
        selectedMeal = SelectedMeal(id: id)
    }
}
