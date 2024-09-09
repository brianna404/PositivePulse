//
//  FontSizeState.swift
//  IOSApp
//
//  Created by Michelle Köhler on 06.09.24.
//

import Foundation

// MARK: - FontSize Enum
// Represents the font sizes which can be selected by the user and show app in chosen font size

enum FontSizeState: String, CaseIterable {
    case small = "Small"
    case medium = "Medium"
    case big = "Big"

    var fontSizeCGFloat: [String: CGFloat] {
        switch self {
        case .small:
            return [
                "extraLargeTitle": 30.0,
                "extraLargTitle2": 22.0,
                "largeTitle": 28.0,
                "title1": 24.0,
                "title2": 18.0,
                "headline": 13.0,
                "callout": 12.0,
                "subheadline": 11.0,
                "body": 13.0,
                "foodnote": 9.0,
                "caption1": 8.0,
                "caption2": 7.0
            ]
        case .medium:
            return [
                "extraLargeTitle": 36.0,
                "extraLargTitle2": 28.0,
                "largeTitle": 34.0,
                "title1": 28.0,
                "title2": 22.0,
                "headline": 17.0,
                "callout": 16.0,
                "subheadline": 15.0,
                "body": 17.0,
                "foodnote": 13.0,
                "caption1": 12.0,
                "caption2": 11.0
            ]
        case .big:
            return [
                "extraLargeTitle": 40.0,
                "extraLargTitle2": 32.0,
                "largeTitle": 38.0,
                "title1": 32.0,
                "title2": 26.0,
                "headline": 21.0,
                "callout": 20.0,
                "subheadline": 19.0,
                "body": 21.0,
                "foodnote": 17.0,
                "caption1": 16.0,
                "caption2": 15.0
            ]
        }
    }
}
