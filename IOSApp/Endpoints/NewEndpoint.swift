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
            case .getNews:
                // Return the query parameters
                return [
                    URLQueryItem(name: "from", value: "\(getDateFromOneWeekAgo())"),
                    URLQueryItem(name: "language", value: "de"),
                    URLQueryItem(name: "sortBy", value: "popularity"),
                    URLQueryItem(name: "domains", value: "tagesschau.de,n-tv.de"),
                    URLQueryItem(name: "pageSize", value: "100"),
                    URLQueryItem(name: "apiKey", value: "69bdfb0d36a24c1da1ec9fe4623de566")
                ]
            }
        }
    //get date from one week ago and format to JSON date format
    func getDateFromOneWeekAgo() -> String {
        let today = Date()
        
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: today)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter.string(from: oneWeekAgo)
    }
}
