//
//  LanguageState.swift
//  IOSApp
//
//  Created by Michelle Köhler on 29.08.24.
//

import Foundation

enum LanguageState: String, CaseIterable {
    case german = "German"
    case english = "English"
    
    var filterValue: String {
        switch self {
        case .german:
            return "de"
        case .english:
            return "eng"
        }
    }
}
