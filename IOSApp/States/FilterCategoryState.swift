//
//  FilterCategoryState.swift
//  IOSApp
//
//  Created by Michelle Köhler on 12.08.24.
//

import Foundation

/// Represents the different news categories that can be selected by the user.
enum FilterCategoryState: String, CaseIterable {
    /// All categories.
    case all = "Alle"
    /// General news.
    case general = "Allgemein"
    /// Business news.
    case business = "Wirtschaft"
    /// Entertainment news.
    case entertainment = "Unterhaltung"
    /// Health news.
    case health = "Gesundheit"
    /// Science news.
    case science = "Wissenschaft"
    /// Sports news.
    case sports = "Sport"
    /// Technology news.
    case technology = "Technologie"
    
    /// The value used for the category parameter in URL requests.
    ///
    /// Returns `nil` for the `.all` category to fetch all categories without filtering.
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
