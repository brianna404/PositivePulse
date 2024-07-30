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
class Article: Codable, Identifiable {
    // attributes
    let id: UUID // id of type universally unique identifier
    let source: String?
    let author, title: String?
    let description: JSONNull?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    let content: JSONNull?
    
    // methods
    // initializer
    init(id: UUID = UUID(), source: Source, author: String, title: String, description: JSONNull?, url: String, urlToImage: JSONNull?, publishedAt: Date, content: JSONNull?) {
        self.id = id // create uuid when an instance is created
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}

extension Article {
    static var dummyData: Article {
        .init(source: Source
            .init(id: "google-news", name: "Google News"),
              author: "tagesschau.de",
              title: "Was über die Brandanschläge auf Frankreichs Bahn bekannt ist - tagesschau.de",
              description: nil,
              url: "https://news.google.com/rss/articles/CBMiTmh0dHBzOi8vd3d3LnRhZ2Vzc2NoYXUuZGUvd2lzc2VuL2dlc3VuZGhlaXQvYmlsYW56LXdlbHQtYWlkcy1rb25ncmVzcy0xMDAuaHRtbNIBAA?oc=5",
              urlToImage: "https://i0.wp.com/electrek.co/wp-content/uploads/sites/3/2024/07/Tesla-model-S-plaid-record.jpg?resize=1200%2C628&quality=82&strip=all&ssl=1",
              publishedAt: Date(),
              content: nil)
    }
}

// MARK: - Source
// class to represent the source of a news article
class Source: Codable {
    // attributes
    let id: String
    let name: String
    
    // methods
    // initializer
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

// MARK: - Enums
// ID Enum defines the possible IDs for news sources
enum ID: String, Codable {
    case googleNews = "google-news"
    // more sources can be added here
}

// Name Enum defines the possible names for news sources
enum Name: String, Codable {
    case googleNews = "Google News"
    // more names can be added here
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
