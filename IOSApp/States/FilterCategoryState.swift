//
//  FilterCategoryState.swift
//  IOSApp
//
//  Created by Michelle Köhler on 12.08.24.
//

import Foundation

// MARK: - FilterCategoryState Enum
// Represents the different categories which can be selected by the user

enum FilterCategoryState: String, CaseIterable {
    case all = "Alle"
    case general = "Allgemein"
    case business = "Business"
    case entertainment = "Unterhaltung"
    case health = "Gesundheit"
    case science = "Wissenschaft"
    case sports = "Sport"
    case technology = "Technologie"
    
    // Value for parameter in URLRequest 
    var filterValue: String? {
        switch self {
        case .all:
            return nil
        case .general:
            return "general"
        case .business:
            return "business"
        case .entertainment:
            return "entertainment"
        case .health:
            return "health"
        case .science:
            return "science"
        case .sports:
            return "sports"
        case .technology:
            return "technology"
        }
    }
}
