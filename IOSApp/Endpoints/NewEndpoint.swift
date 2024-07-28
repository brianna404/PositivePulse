//
//  NewEndpoint.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

// MARK: - APIBuilder Protocol
// protocol to define the requirements for building a URLRequest
protocol APIBuilder {
    var URLRequest: URLRequest { get }
    var baseURL: URL { get }
    var path: String { get }
}

// MARK: - NewsAPI Enum
// represent different API endpoints
enum NewsAPI {
    case getNews
    // more can be added here
}

// MARK: - Conformance to APIBuilder
// extending NewsAPI to conform to the APIBuilder protocol
extension NewsAPI: APIBuilder {
    // URLRequest builds the complete URLRequest for the given API endpoint
    var URLRequest: URLRequest {
        // construct a URLRequest using the baseURL and path for the endpoint.
        return Foundation.URLRequest(url: self.baseURL.appendingPathComponent(self.path))
    }
    // baseURL returns the base URL for the API
    var baseURL: URL {
        switch self {
        case .getNews:
            // Return the base URL
            return URL(string: "https://newsapi.org")!
        }
    }
    // path returns the specific path and query parameters for the API endpoint
    var path: String {
        // Return the path for the news headlines endpoint with query parameters
        return "/v2/top-headlines?country=de&apiKey=69bdfb0d36a24c1da1ec9fe4623de566"
    }
}
