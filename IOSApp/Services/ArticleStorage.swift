//
//  ArticleStorage.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 06.08.24.
//

import Foundation

class ArticleStorage {
    // define keys for sets
    private let readArticlesKey = "readArticles"
    private let bookmarkedArticlesKey = "bookmarkedArticles"
    
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
        return fetchArticles(forKey: readArticlesKey)
    }
    
    // Save bookmarked articles
    func saveBookmarkedArticles(_ articles: Set<Article>) {
        saveArticles(articles: articles, forKey: bookmarkedArticlesKey)
    }
    
    // Fetch bookmarked articles
    func fetchBookmarkedArticles() -> Set<Article> {
        return fetchArticles(forKey: bookmarkedArticlesKey)
    }
    
    // Add or update an article
    func addOrUpdateArticle(_ article: Article) {
        var readArticles = fetchReadArticles()
        var bookmarkedArticles = fetchBookmarkedArticles()
        
        // Handle read articles
        if article.isRead ?? false { // provide false as default if nil
            readArticles.update(with: article) // Use update to ensure uniqueness
            } else {
                readArticles.remove(article)
            }
        saveReadArticles(readArticles)

        
        // Handle bookmarked articles
        if article.isBookmarked ?? false { // provide false as default if nil
            bookmarkedArticles.update(with: article) // Use update to ensure uniqueness
            } else {
                bookmarkedArticles.remove(article)
            }
        saveBookmarkedArticles(bookmarkedArticles)
    }
    
    // Toggle the bookmark status of an article
    func toggleBookmark(for article: Article) -> Article {
        let updatedArticle = article
        updatedArticle.isBookmarked = !(article.isBookmarked ?? false)
        addOrUpdateArticle(updatedArticle)
        return updatedArticle
    }
}
