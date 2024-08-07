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
    let results: [Article]
    let nextPage: String
    
    // methods
    // initializer
    init(status: String, totalResults: Int, results: [Article], nextPage: String) {
        self.status = status
        self.totalResults = totalResults
        self.results = results
        self.nextPage = nextPage
    }
}

// MARK: - Article
// class to represent a single news article
class Article: Codable, Identifiable {
    // attributes
    //some parameters are not available in api request version
    let article_id: String?
    let title: String?
    let link: String?
    let keywords: Array<String>?
    let creator: Array<String>?
    let video_url: String?
    let description: String?
    let content: String?
    let pubDate: String?
    let image_url: String?
    let source_id: String?
    let source_priority: Int?
    let source_name: String?
    let source_url: String?
    let source_icon: String?
    let language: String?
    let country: Array<String>?
    let category: Array<String>?
    let ai_tag: String?
    let sentiment: String?
    let sentiment_stats: String?
    let ai_region: String?
    let ai_org: String?
    let duplicate: Bool
    
    // Attributes specific to the app
    var isRead: Bool = false
    var isBookmarked: Bool = false
    
    // initializer
    init(articleID: String?, title: String?, link: String?, keywords: Array<String>?, creator: Array<String>?, videoURL: String?, description: String?, content: String?, pubDate: String?, imageURL: String?, sourceID: String?, sourcePriority: Int?, sourceName: String?, sourceURL: String?, sourceIcon: String?, language: String?, country: Array<String>?, category: Array<String>?, aiTag: String?, sentiment: String?, sentimentStats: String?, aiRegion: String?, aiOrg: String?, duplicate: Bool, isRead: Bool, isBookmarked: Bool) {
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
// Enums of arrays of article parameter
enum Keyword: String, Codable {
    case politik = "politik"
}
enum Country: String, Codable {
    case germany = "germany"
}
enum Category: String, Codable {
    case politics = "politics"
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
    public var hashValue: Int {
                return 0
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
