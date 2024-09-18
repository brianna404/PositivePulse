//
//  NewEndpoint.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

// MARK: - APIBuilder Protocol
// Protocol to define the requirements for building a URLRequest

protocol APIBuilder {
    var request: URLRequest { get }
    var baseURL: URL { get }
    var path: String { get }
}

// MARK: - NewsAPI Enum
// Represents different API endpoints

enum NewsAPI {
    case getNews(category: String?, keyword: String?, country: String?)
    // More can be added here
}

// MARK: - Conformance to APIBuilder
// Extending NewsAPI to conform to the APIBuilder protocol

extension NewsAPI: APIBuilder {
    
    // URLRequest builds the complete URLRequest for the given API endpoint
    var request: URLRequest {
        
        // Construct a URLRequest using the baseURL and path for the endpoint
        var urlComponents = URLComponents(url: self.baseURL.appendingPathComponent(self.path), resolvingAgainstBaseURL: false)!
            // Add filters in form of array of query items
                urlComponents.queryItems = self.queryItems

                // Return error if URL invalid
                guard let url = urlComponents.url else {
                    fatalError("Invalid URL components")
                }
        
                // Return constructed URL
                return URLRequest(url: url)
    }
    
    // BaseURL returns the base URL for the API
    var baseURL: URL {
        
        switch self {
        case .getNews:
            // Return the base URL
            return URL(string: "https://newsapi.org")!
        }
    }
    
    // Path returns the specific path for the API endpoint
        var path: String {
            switch self {
            case .getNews:
                // Return the specific path
                return "/v2/top-headlines"
            }
        }
    
    // QueryItems returns the filters as query parameters for the API endpoint
    var queryItems: [URLQueryItem] {
        
        switch self {
        case .getNews(let category, let keyword, let country):
            // Load the API key from the Config.plist file
            guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
                  let config = NSDictionary(contentsOfFile: path),
                  let apiKey = config["API_KEY"] as? String
            else {
                fatalError("Required parameters missing or invalid")
            }
            
            // General filters as query items
            var queryItems = [
                URLQueryItem(name: "country", value: country),
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
            
            // Return filters as array of query items
            return queryItems
        }
    }
}
