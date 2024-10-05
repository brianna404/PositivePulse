//
//  ResultState.swift
//  PositivePulse
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

/// Represents the different states of an asynchronous operation fetching news articles.
enum ResultState {
    /// The operation is currently in progress.
    case loading

    /// The operation was successful and contains the fetched articles.
    ///
    /// - Parameter content: An array of `Article` objects that were fetched.
    case success(content: [Article])

    /// The operation failed with an error.
    ///
    /// - Parameter error: An `Error` object describing the failure.
    case failed(error: Error)
}
