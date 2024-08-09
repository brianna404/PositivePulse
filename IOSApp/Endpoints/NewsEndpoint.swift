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
    var request: URLRequest { get }
    var baseURL: URL { get }
    var path: String { get }
}

// MARK: - NewsAPI Enum
// represent different API endpoints
enum NewsAPI {
    case getNews
    case getMoreNews(pageNr: String)
    // more can be added here
}

// MARK: - Conformance to APIBuilder
// extending NewsAPI to conform to the APIBuilder protocol
extension NewsAPI: APIBuilder {
    // URLRequest builds the complete URLRequest for the given API endpoint
    var request: URLRequest {
        // construct a URLRequest using the baseURL and path for the endpoint.
        var urlComponents = URLComponents(url: self.baseURL.appendingPathComponent(self.path), resolvingAgainstBaseURL: false)!
                urlComponents.queryItems = self.queryItems

                guard let url = urlComponents.url else {
                    fatalError("Invalid URL components")
                }
        
                return URLRequest(url: url)
    }
    // baseURL returns the base URL for the API
    var baseURL: URL {
        switch self {
        case .getNews, .getMoreNews:
            // Return the base URL
            return URL(string: "https://newsdata.io")!
        }
    }
    // path returns the specific path for the API endpoint
        var path: String {
            switch self {
            case .getNews, .getMoreNews:
                // Return the specific path
                return "/api/1/latest"
            }
        }
    // queryItems returns the query parameters for the API endpoint
        var queryItems: [URLQueryItem] {
            var baseQueryItems = [
                URLQueryItem(name: "language", value: "de"),
                URLQueryItem(name: "domain", value: "n-tv, focus, zeit, faz, tagesschau"),
                URLQueryItem(name: "removeduplicate", value: "1"),
                URLQueryItem(name: "apikey", value: "pub_499417547ff0609b0d2cf505bdd1ec31d8090")
            ]
            switch self {
            case .getNews:
                // Return the query parameters
                return baseQueryItems
            case .getMoreNews(let pageNr):
                let newPageQueryItem = URLQueryItem(name: "page", value: "\(pageNr)")
                baseQueryItems.append(newPageQueryItem)
                // Return the query parameters
                return baseQueryItems
            }
        }
}
