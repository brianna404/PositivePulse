//
//  FilterCategoryState.swift
//  IOSApp
//
//  Created by Michelle Köhler on 12.08.24.
//

import Foundation
import SwiftUI

// MARK: - FilterCategoryState Enum
enum FilterCategoryState: String, CaseIterable {
    case general = "Allgemein"
    case business = "Business"
    case entertainment = "Unterhaltung"
    case health = "Gesundheit"
    case science = "Wissenschaft"
    case sports = "Sport"
    case technology = "Technologie"
    
    var filterValue: String {
        switch self {
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
