//
//  ArticleStorageService.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 06.08.24.
//

import Foundation

class ArticleStorageService: ObservableObject {
    // define keys for sets
    private let readArticlesKey = "readArticles"
    private let bookmarkedArticlesKey = "bookmarkedArticles"
    
    // singleton instance to provide single source of truth with global access
    static let shared = ArticleStorageService()
    
    // published bookmarked articles (writing only from here, reading from everywhere possible)
    // needed to ensure the fill of the icon is immeadetely displayed correctly when toggling
    @Published private(set) var bookmarkedArticles: Set<Article> = []

    init() {
        // populate with bookmarked articles from past app sessions
        self.bookmarkedArticles = fetchBookmarkedArticles()
    }
    
    // Function to save articles
    func saveArticles(articles: Set<Article>, forKey key: String) {
        if let data = try? JSONEncoder().encode(Array(articles)) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    // Function to fetch articles
    func fetchArticles(forKey key: String) -> Set<Article> {
        if let data = UserDefaults.standard.data(forKey: key),
           let articles = try? JSONDecoder().decode([Article].self, from: data) {
            return Set(articles)
        }
        return []
    }
    
    // Save read articles
    func saveReadArticles(_ articles: Set<Article>) {
        saveArticles(articles: articles, forKey: readArticlesKey)
    }
    
    // Fetch read articles (not older than 30 days ago)
    func fetchReadArticles() -> Set<Article> {
        // fetch all read articles
        let readArticles = fetchArticles(forKey: readArticlesKey)
        
        // Get the date 30 days ago
         guard let daysAgoString = DateUtils.dateAgo(daysAgo: 30),
               
               let daysAgoDate = DateUtils.dateFromString(daysAgoString, fromFormat: "yyyy-MM-dd") else {
             return []
         }
        
        // Filter the articles to return only those published within the last 30 days
        let filteredArticles = readArticles.filter { article in
            if let pubDate = article.publishedAt,
               let articleDate = DateUtils.dateFromString(pubDate, fromFormat: "yyyy-MM-dd'T'HH:mm:ssZ") {
                return articleDate >= daysAgoDate
            }
            return false
        }
        return filteredArticles
    }
    
    // Save bookmarked articles
    func saveBookmarkedArticles(_ articles: Set<Article>) {
        saveArticles(articles: articles, forKey: bookmarkedArticlesKey)
    }
    
    // Fetch bookmarked articles
    func fetchBookmarkedArticles() -> Set<Article> {
        return fetchArticles(forKey: bookmarkedArticlesKey)
    }
    
    // Update logic when an article is read
    func markArticleAsRead(_ article: Article) {
        let updatedArticle = article
        updatedArticle.isRead = true
        updatedArticle.lastRead = Date()
        
        // Fetch the current read articles
        var readArticles = fetchReadArticles()
        
        // Update the set with the read article
        readArticles.update(with: updatedArticle)
        
        // Save the updated set
        saveReadArticles(readArticles)
    }
    
    // Toggle the bookmark status of an article
    func toggleBookmark(for article: Article) {
        let updatedArticle = article
        // update bookmark status
        updatedArticle.isBookmarked = !(article.isBookmarked ?? false)
        // Set or clear lastBookmarked date
        updatedArticle.lastBookmarked = updatedArticle.isBookmarked ?? false ? Date() : nil
        
        if updatedArticle.isBookmarked ?? false {
            // If the article is bookmarked, add/update it in the set
            bookmarkedArticles.update(with: updatedArticle)
        } else {
            // If the article is not bookmarked, remove it from the set
            bookmarkedArticles.remove(updatedArticle)
        }
        
        // Save the updated set
        saveBookmarkedArticles(bookmarkedArticles)
    }
}
