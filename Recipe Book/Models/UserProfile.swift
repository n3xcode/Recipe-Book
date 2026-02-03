//
//  UserProfile.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/02/02.
//

import Foundation

enum Avatar: String, CaseIterable, Identifiable {
    case ProfilePicture1
    case ProfilePicture2
    case ProfilePicture3
    case ProfilePicture4
    case ProfilePicture5
    case ProfilePicture6

    var id: String { rawValue }
}

enum UserSettingsKey: String {
    case username
    case email
    case profilePictureIndex
    case dietPreference
    case isPremium
    case useMetricUnits
    case showNutritionInfo
}

