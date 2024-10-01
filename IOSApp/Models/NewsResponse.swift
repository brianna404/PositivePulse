//
//  NewsResponse.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

/// Represents the structure of the response from the news API.
class NewsResponse: Codable {
    
    /// Status of the response.
    let status: String
    /// Total number of results.
    let totalResults: Int
    /// Array of fetched articles.
    let articles: [Article]
    
    /// Initializes a new `NewsResponse`.
    ///
    /// - Parameters:
    ///   - status: The status of the response.
    ///   - totalResults: The total number of results.
    ///   - articles: The array of articles.
    init(status: String, totalResults: Int, articles: [Article]) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}

/// Represents a single news article.
class Article: Codable, Identifiable, Hashable, Equatable {
    
    /// Unique identifier since no ID is provided by the API.
    let id: UUID = UUID()
    /// Source information.
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
    // App-specific attributes
    var isRead: Bool?
    var lastRead: Date?
    var isBookmarked: Bool?
    var lastBookmarked: Date?
    
    /// Initializes a new `Article`.
    ///
    /// - Parameters:
    ///   - source: The source of the article.
    ///   - author: The author of the article.
    ///   - title: The title of the article.
    ///   - description: The description of the article.
    ///   - url: The URL of the article.
    ///   - urlToImage: The URL to the article's image.
    ///   - publishedAt: The publication date.
    ///   - content: The content of the article.
    ///   - isRead: Indicates if the article has been read.
    ///   - lastRead: The date the article was last read.
    ///   - isBookmarked: Indicates if the article is bookmarked.
    ///   - lastBookmarked: The date the article was last bookmarked.
    init(
        source: Source?,
        author: String?,
        title: String?,
        description: String?,
        url: String?,
        urlToImage: String?,
        publishedAt: String?,
        content: String?,
        isRead: Bool?,
        lastRead: Date?,
        isBookmarked: Bool?,
        lastBookmarked: Date?
    ) {
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
    
    /// Hashes the essential components of the article.
    func hash(into hasher: inout Hasher) {
        hasher.combine(url) // URL is assumed unique per article
    }
    
    /// Checks if two articles are equal based on their URL.
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.url == rhs.url
    }
}

/// Represents the source of a news article.
class Source: Codable {
    
    let id: String?
    let name: String?
    
    /// Initializes a new `Source`.
    ///
    /// - Parameters:
    ///   - id: The identifier of the source.
    ///   - name: The name of the source.
    init(id: String?, name: String?) {
        self.id = id
        self.name = name
    }
}
