//
//  APIError.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

/// Defines different types of possible API interaction errors.
enum APIError: Error, Equatable {
    /// Error in decoding the response.
    case decodingError
    /// HTTP error with associated status code.
    case errorCode(Int)
    /// No articles available.
    case noArticles
    /// Unknown error occurred.
    case unknown
    
    /// Implements Equatable for custom comparison.
    static func ==(lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.decodingError, .decodingError),
             (.noArticles, .noArticles),
             (.unknown, .unknown):
            return true
        case (.errorCode(let lhsCode), .errorCode(let rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
        }
    }
}

extension APIError: LocalizedError {
    /// Provides localized error descriptions.
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Failed to decode object from service."
        case .errorCode(let code):
            if code == 429 {
                return "Too many requests. Please try again later."
            }
            return "\(code) - Something went wrong."
        case .noArticles:
            return "No articles available at the moment. Please try again later."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
