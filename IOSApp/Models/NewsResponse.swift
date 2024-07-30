//
//  NewsResponse.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

// MARK: - NewsResponse
struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable, Identifiable {
    let id = UUID()
    let source: Source?
    let author, title: String?
    let description: JSONNull?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    let content: JSONNull?
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
struct Source: Codable {
    let id: String
    let name: String
}

enum ID: String, Codable {
    case googleNews = "google-news"
}

enum Name: String, Codable {
    case googleNews = "Google News"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
