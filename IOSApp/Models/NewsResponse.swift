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
    let id: UUID = UUID() // id of type universally unique identifier
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
<<<<<<< HEAD
    // methods
    // initializer
    init(source: Source?, author: String?, title: String?, description: String?, url: String?, urlToImage: String?, publishedAt: String?, content: String?) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
=======
    // Attributes specific to the app
    var isRead: Bool?
    var isBookmarked: Bool?
    
    // initializer
    init(articleID: String?, title: String?, link: String?, keywords: Array<String>?, creator: Array<String>?, videoURL: String?, description: String?, content: String?, pubDate: String?, imageURL: String?, sourceID: String?, sourcePriority: Int?, sourceName: String?, sourceURL: String?, sourceIcon: String?, language: String?, country: Array<String>?, category: Array<String>?, aiTag: String?, sentiment: String?, sentimentStats: String?, aiRegion: String?, aiOrg: String?, duplicate: Bool, isRead: Bool? = false, isBookmarked: Bool? = false) {
            self.article_id = articleID
            self.title = title
            self.link = link
            self.keywords = keywords
            self.creator = creator
            self.video_url = videoURL
            self.description = description
            self.content = content
            self.pubDate = pubDate
            self.image_url = imageURL
            self.source_id = sourceID
            self.source_priority = sourcePriority
            self.source_name = sourceName
            self.source_url = sourceURL
            self.source_icon = sourceIcon
            self.language = language
            self.country = country
            self.category = category
            self.ai_tag = aiTag
            self.sentiment = sentiment
            self.sentiment_stats = sentimentStats
            self.ai_region = aiRegion
            self.ai_org = aiOrg
            self.duplicate = duplicate
            self.isRead = isRead
            self.isBookmarked = isBookmarked
        }
>>>>>>> main
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
