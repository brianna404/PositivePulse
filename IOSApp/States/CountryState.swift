//
//  CountryState.swift
//  IOSApp
//
//  Created by Michelle Köhler on 28.08.24.
//

import Foundation

// MARK: - CountryState Enum
// Represents the different countrie which can be selected by the user and loads articles from different countries

enum CountryState: String, CaseIterable {
    case germany = "Germany"
    case austria = "Austria"
    case switzerland = "Switzerland"
    case unitedKingdom = "United Kingdom"
    case unitedStates = "United States"
    case canada = "Canada"
    
    // Value for parameter in URLRequest
    var filterValue: String {
        switch self {
        case .germany:
            return "de"
        case .austria:
            return "at"
        case .switzerland:
            return "ch"
        case .unitedKingdom:
            return "gb"
        case .unitedStates:
            return "us"
        case .canada:
            return "ca"
        }
    }
}
