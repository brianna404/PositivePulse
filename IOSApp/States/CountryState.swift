//
//  CountryState.swift
//  IOSApp
//
//  Created by Michelle Köhler on 28.08.24.
//

import Foundation

// MARK: - CountryState Enum
enum CountryState: String, CaseIterable {
    case germany = "Germany"
    case austria = "Austria"
    case switzerland = "Schwitzerland"
    case unitedKingdom = "United Kingdom"
    case unitedStates = "United States"
    case canada = "Canada"
    
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
