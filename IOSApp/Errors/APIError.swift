//
//  APIError.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

// MARK: - APIError Enum
// Define different types of possible API interaction errors

enum APIError: Error, Equatable {
    case decodingError
    // Associates a HTTP status code with the error
    case errorCode(Int)
    case noArticles
    case unkown
    
    // Implementing Equatable for custom comparison
    static func ==(lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.decodingError, .decodingError),
             (.noArticles, .noArticles),
             (.unkown, .unkown):
            return true
        case (.errorCode(let lhsCode), .errorCode(let rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
        }
    }
}

// MARK: - LocalizedError Conformance
// Extending APIError to conform to LocalizedError for providing error descriptions

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Failed to decode object from service"
        case .errorCode(let code):
            if code == 429 {
                return "Too many requests. Please try again later."
            }
            // Description for errors associated with specific HTTP status codes
            return "\(code) - something went wrong"
        case .noArticles:
            return "No articles available at the moment. Please try again later"
        case .unkown:
            return "This error is unknown"
        }
    }
}
