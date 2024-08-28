//
//  NewsResponse.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

// MARK: - NewsResponse
// class to represent the structure of the response from the news API
class NewsResponse: Codable {
    // attributes
    let status: String
    let totalResults: Int
    let articles: [Article]
    
    // methods
    // initializer
    init(status: String, totalResults: Int, articles: [Article]) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}

// MARK: - Article
// class to represent a single news article
class Article: Codable, Identifiable, Hashable, Equatable {
    // attributes
    let id: UUID = UUID() // id of type universally unique identifier
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
    // Attributes specific to the app
    // History
    var isRead: Bool?
    var lastRead: Date?
    // Bookmarking
    var isBookmarked: Bool?
    var lastBookmarked: Date?
    
    // methods
    // initializer
    init(source: Source?, author: String?, title: String?, description: String?, url: String?, urlToImage: String?, publishedAt: String?, content: String?, isRead: Bool?, lastRead: Date?, isBookmarked: Bool?, lastBookmarked: Date?) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
        self.isRead = isRead
        self.lastRead = lastRead
        self.isBookmarked = isBookmarked
        self.lastBookmarked = lastBookmarked
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(url) // Assuming the URL is unique for each article
    }
    
    // MARK: - Equatable
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.url == rhs.url // Assuming the URL is unique for each article
    }
}
    

// MARK: - Source
// class to represent the source of a news article
class Source: Codable {
    // attributes
    let id: String?
    let name: String?
    
    // methods
    // initializer
    init(id: String?, name: String?) {
        self.id = id
        self.name = name
    }
}

// MARK: - Encode/decode helpers
// class to handle null values in JSON data
class JSONNull: Codable, Hashable {

    // methods
    // equality operator for JSONNull, as all instances are considered equal
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    // hash value for JSONNull. All instances have the same hash value
    public func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }

    // initializer
    public init() {} // no-op initializer since JSONNull does not need any properties initialized

    // Required initializer for decoding JSONNull from JSON data
    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() { // throws an error if the JSON value is not null
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    // encode JSONNull into JSON data
    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
