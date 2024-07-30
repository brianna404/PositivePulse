//
//  APIError.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

// MARK: - APIError Enum
// define different types of possible API interaction errors
enum APIError: Error {
    case decodingError
    case errorCode(Int) // associates a HTTP status code with the error.
    case unkown
}

// MARK: - LocalizedError Conformance
// extending APIError to conform to LocalizedError for providing error descriptions
extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Failed to decode object from service"
        case .errorCode(let code):
            return "\(code) - something went wrong" // description for errors associated with specific HTTP status codes

        case .unkown:
            return "This error is unknown"
        }
    }
}
