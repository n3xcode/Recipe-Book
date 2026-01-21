//
//  PageTurnStyle.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/20.
//

import Foundation


enum DietaryPreferenceOptions: CaseIterable {
    
    case none
    case vegetarian
    case vegan
    case glutenFree
    case dairyFree
    case keto
    case paleo
    case pescatarian

    var title: String {
        switch self {
        case .none:
            return "None"
        case .vegetarian:
            return "Vegetarian"
        case .vegan:
            return "Vegan"
        case .glutenFree:
            return "Gluten-Free"
        case .dairyFree:
            return "Dairy-Free/Lactose-Free"
        case .keto:
            return "Ketogenic"
        case .paleo:
            return "Paleo"
        case .pescatarian:
            return "Pescatarian"
            
        }
    }
}
