//
//  APIError.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

// MARK: - APIError Enum
// Define different types of possible API interaction errors
enum APIError: Error {
    case decodingError
    // Associates a HTTP status code with the error
    case errorCode(Int)
    case unkown
}

// MARK: - LocalizedError Conformance
// Extending APIError to conform to LocalizedError for providing error descriptions
extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Failed to decode object from service"
        case .errorCode(let code):
            // Description for errors associated with specific HTTP status codes
            return "\(code) - something went wrong"
        case .unkown:
            return "This error is unknown"
        }
    }
}
