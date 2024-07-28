//
//  APIError.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

enum APIError: Error {
    case decodingError
    case errorCode(Int)
    case unkown
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Failed to decode object from service"
        case .errorCode(let code):
            return "\(code) - something went wrong"
        case .unkown:
            return "This error is unknown"
        }
    }
}
