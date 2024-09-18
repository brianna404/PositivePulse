//
//  ResultState.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

// MARK: - ResultState Enum
// Represents the different states of asynchronous operation

enum ResultState {
    // Operation in progress
    case loading
    // Operation successfull, contains array of articles
    case success(content: [Article])
    // Failed, contains error description
    case failed(error: Error)
}
