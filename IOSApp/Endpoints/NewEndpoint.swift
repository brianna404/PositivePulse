//
//  NewEndpoint.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

protocol APIBuilder {
    var URLRequest: URLRequest { get }
    var baseURL: URL { get }
    var path: String { get }
}

enum NewsAPI {
    case getNews
}

extension NewsAPI: APIBuilder {
    var URLRequest: URLRequest {
        return Foundation.URLRequest(url: self.baseURL.appendingPathComponent(self.path))
    }
    
    var baseURL: URL {
        switch self {
        case .getNews:
            return URL(string: "https://newsapi.org")!
        }
    }
    
    var path: String {
        return "/v2/top-headlines?country=de&apiKey=69bdfb0d36a24c1da1ec9fe4623de566"
    }
}
