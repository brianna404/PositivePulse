//
//  ArticleStorageService.swift
//  PositivePulse
//
//  Created by Brianna Kruschke on 06.08.24.
//

import Foundation

/// A service responsible for storing and managing articles that have been read or bookmarked.
/// Provides functionality to save and retrieve articles from persistent storage (UserDefaults).
class ArticleStorageService: ObservableObject {
    
    // MARK: - Properties
    
    /// Key used to store and retrieve read articles from UserDefaults.
    private let readArticlesKey = "readArticles"
    
    /// Key used to store and retrieve bookmarked articles from UserDefaults.
    private let bookmarkedArticlesKey = "bookmarkedArticles"
    
    /// Singleton instance to provide a single source of truth with global access.
    static let shared = ArticleStorageService()
    
    /// A published set of bookmarked articles.
    /// Writing is only performed from this service; reading can be done from anywhere.
    /// Needed to ensure the bookmark icon updates immediately when toggling.
    @Published private(set) var bookmarkedArticles: Set<Article> = []

    // MARK: - Initialization
    
    /// Initializes the service by loading bookmarked articles from persistent storage.
    private init() {
        // Populate with bookmarked articles from previous app sessions.
        self.bookmarkedArticles = fetchBookmarkedArticles()
    }
    
    // MARK: - Article Saving and Fetching Methods
    
    /// Saves a set of articles to UserDefaults under the specified key.
    ///
    /// - Parameters:
    ///   - articles: The set of articles to save.
    ///   - key: The key under which to store the articles.
    private func saveArticles(articles: Set<Article>, forKey key: String) {
        if let data = try? JSONEncoder().encode(Array(articles)) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    /// Fetches a set of articles from UserDefaults for the specified key.
    ///
    /// - Parameter key: The key under which the articles are stored.
    /// - Returns: A set of `Article` objects, or an empty set if none are found.
    private func fetchArticles(forKey key: String) -> Set<Article> {
        if let data = UserDefaults.standard.data(forKey: key),
           let articles = try? JSONDecoder().decode([Article].self, from: data) {
            return Set(articles)
        }
        return []
    }
    
    /// Saves the set of read articles to persistent storage.
    ///
    /// - Parameter articles: The set of read articles to save.
    private func saveReadArticles(_ articles: Set<Article>) {
        saveArticles(articles: articles, forKey: readArticlesKey)
    }
    
    /// Fetches the set of read articles from persistent storage, filtering out articles older than 30 days.
    ///
    /// - Returns: A set of `Article` objects that have been read within the last 30 days.
    func fetchReadArticles() -> Set<Article> {
        // Fetch all read articles from storage.
        let readArticles = fetchArticles(forKey: readArticlesKey)
        
        // Get the date 30 days ago.
        guard let daysAgoString = DateUtils.dateAgo(daysAgo: 30),
              let daysAgoDate = DateUtils.dateFromString(daysAgoString, fromFormat: "yyyy-MM-dd") else {
            return []
        }
        
        // Filter articles to include only those read within the last 30 days.
        let filteredArticles = readArticles.filter { article in
            if let pubDate = article.publishedAt,
               let articleDate = DateUtils.dateFromString(pubDate, fromFormat: "yyyy-MM-dd'T'HH:mm:ssZ") {
                return articleDate >= daysAgoDate
            }
            return false
        }
        return filteredArticles
    }
    
    /// Saves the set of bookmarked articles to persistent storage.
    ///
    /// - Parameter articles: The set of bookmarked articles to save.
    private func saveBookmarkedArticles(_ articles: Set<Article>) {
        saveArticles(articles: articles, forKey: bookmarkedArticlesKey)
    }
    
    /// Fetches the set of bookmarked articles from persistent storage.
    ///
    /// - Returns: A set of `Article` objects that have been bookmarked.
    func fetchBookmarkedArticles() -> Set<Article> {
        return fetchArticles(forKey: bookmarkedArticlesKey)
    }
    
    // MARK: - Article Update Methods
    
    /// Marks an article as read, updates its read timestamp, and saves it to persistent storage.
    ///
    /// - Parameter article: The `Article` object to mark as read.
    func markArticleAsRead(_ article: Article) {
        let updatedArticle = article
        updatedArticle.isRead = true
        updatedArticle.lastRead = Date()
        
        // Fetch the current set of read articles.
        var readArticles = fetchReadArticles()
        
        // Update the set with the newly read article.
        readArticles.update(with: updatedArticle)
        
        // Save the updated set back to storage.
        saveReadArticles(readArticles)
    }
    
    /// Toggles the bookmark status of an article and updates the bookmarked articles set.
    ///
    /// - Parameter article: The `Article` object whose bookmark status is to be toggled.
    func toggleBookmark(for article: Article) {
        let updatedArticle = article
        // Toggle the bookmark status.
        updatedArticle.isBookmarked = !(article.isBookmarked ?? false)
        // Set or clear the lastBookmarked date based on the new status.
        updatedArticle.lastBookmarked = updatedArticle.isBookmarked ?? false ? Date() : nil
        
        if updatedArticle.isBookmarked ?? false {
            // If the article is now bookmarked, add or update it in the set.
            bookmarkedArticles.update(with: updatedArticle)
        } else {
            // If the article is no longer bookmarked, remove it from the set.
            bookmarkedArticles.remove(updatedArticle)
        }
        
        // Save the updated set of bookmarked articles.
        saveBookmarkedArticles(bookmarkedArticles)
    }
}
