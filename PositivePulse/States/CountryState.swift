//
//  CountryState.swift
//  PositivePulse
//
//  Created by Michelle Köhler on 28.08.24.
//

import Foundation

/// Represents the different countries that can be selected by the user to load articles from.
enum CountryState: String, CaseIterable {
    /// Germany
    case germany = "Deutschland"
    /// Austria
    case austria = "Österreich"
    /// Switzerland
    case switzerland = "Schweiz"
    /// United Kingdom
    case unitedKingdom = "Großbritannien"
    /// United States
    case unitedStates = "USA"
    /// Canada
    case canada = "Kanada"
    
    /// The country code used for the `country` parameter in URL requests.
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
