//
//  ResultState.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

// MARK: - ResultState Enum
// represent the different states of asynchronous operation
enum ResultState {
    case loading // operation in progress
    case success(content: [Article]) // operation successfull, contains array of articles
    case failed(error: Error) // failed, contains error description
}
