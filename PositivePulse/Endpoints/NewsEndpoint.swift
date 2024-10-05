//
//  NewsEndpoint.swift
//  PositivePulse
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

/// Protocol defining the requirements for building a URLRequest.
protocol APIBuilder {
    /// Builds the complete URLRequest for the given API endpoint.
    var request: URLRequest { get }
    /// The base URL for the API.
    var baseURL: URL { get }
    /// The specific path for the API endpoint.
    var path: String { get }
}

/// Represents different API endpoints.
enum NewsAPI {
    /// Endpoint to get news with optional filters.
    case getNews(category: String?, keyword: String?, country: String?)
    // Additional endpoints can be added here.
}

/// Extends NewsAPI to conform to the APIBuilder protocol.
extension NewsAPI: APIBuilder {
    
    /// Builds the complete URLRequest for the given API endpoint.
    var request: URLRequest {
        // Construct URL components using baseURL and path.
        var urlComponents = URLComponents(
            url: self.baseURL.appendingPathComponent(self.path),
            resolvingAgainstBaseURL: false
        )!
        
        // Add query items (filters).
        urlComponents.queryItems = self.queryItems

        // Ensure the URL is valid.
        guard let url = urlComponents.url else {
            fatalError("Invalid URL components")
        }
        
        // Return the constructed URLRequest.
        return URLRequest(url: url)
    }
    
    /// The base URL for the API.
    var baseURL: URL {
        switch self {
        case .getNews:
            return URL(string: "https://newsapi.org")!
        }
    }
    
    /// The specific path for the API endpoint.
    var path: String {
        switch self {
        case .getNews:
            return "/v2/top-headlines"
        }
    }
    
    /// Returns the filters as query parameters for the API endpoint.
    var queryItems: [URLQueryItem] {
        switch self {
        case .getNews(let category, let keyword, let country):
            // Load the API key from the Config.plist file.
            guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
                  let config = NSDictionary(contentsOfFile: path),
                  let apiKey = config["API_KEY"] as? String
            else {
                fatalError("Required parameters missing or invalid")
            }
            
            // General filters as query items.
            var queryItems = [
                URLQueryItem(name: "country", value: country),
                URLQueryItem(name: "pageSize", value: "100"),
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
            
            // Add category if provided.
            if let category = category {
                queryItems.append(URLQueryItem(name: "category", value: category))
            }
            
            // Add keyword if provided.
            if let keyword = keyword, !keyword.isEmpty {
                queryItems.append(URLQueryItem(name: "q", value: keyword))
            }
            
            // Return the array of query items.
            return queryItems
        }
    }
}
