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
    case getNews(category: String?, keyword: String?)
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
        case .getNews:
            // Return the base URL
            return URL(string: "https://newsapi.org")!
        }
    }
    // path returns the specific path for the API endpoint
        var path: String {
            switch self {
            case .getNews:
                // Return the specific path
                return "/v2/top-headlines"
            }
        }
    // queryItems returns the query parameters for the API endpoint
    var queryItems: [URLQueryItem] {
        switch self {
        case .getNews(let category, let keyword):
            // Load the API key from the Config.plist file
            guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
                  let config = NSDictionary(contentsOfFile: path),
                  let apiKey = config["API_KEY"] as? String
            else {
                fatalError("Required parameters missing or invalid")
            }
            
            // general query items
            var queryItems = [
                URLQueryItem(name: "language", value: "de"),
                URLQueryItem(name: "pageSize", value: "100"),
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
            
            // Add the category query item if a category is provided
            if let category = category {
                queryItems.append(URLQueryItem(name: "category", value: category))
            }
            
            // Add the keyword query item if a keyword is provided
            if let keyword = keyword, !keyword.isEmpty {
                queryItems.append(URLQueryItem(name: "q", value: keyword))
            }
            
            return queryItems
        }
    }
}
