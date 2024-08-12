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
    func saveArticles(articles: [Article], forKey key: String) {
        if let data = try? JSONEncoder().encode(articles) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    // Function to fetch articles
    func fetchArticles(forKey key: String) -> [Article] {
        if let data = UserDefaults.standard.data(forKey: key),
           let articles = try? JSONDecoder().decode([Article].self, from: data) {
            return articles
        }
        return []
    }
    
    // Save read articles
    func saveReadArticles(_ articles: [Article]) {
        saveArticles(articles: articles, forKey: readArticlesKey)
    }
    
    // Fetch read articles
    func fetchReadArticles() -> [Article] {
        let articles = fetchArticles(forKey: readArticlesKey)
        let daysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())
               
        return articles.filter { article in
            if let pubDate = article.publishedAt, let date = DateUtils.dateFromString(pubDate, fromFormat: "yyyy-MM-dd  HH:mm:ss"), let daysAgo = daysAgo {
                return date >= daysAgo
            }
            return false
        }
    }
    
    // Save bookmarked articles
    func saveBookmarkedArticles(_ articles: [Article]) {
        saveArticles(articles: articles, forKey: bookmarkedArticlesKey)
    }
    
    // Fetch bookmarked articles
    func fetchBookmarkedArticles() -> [Article] {
        return fetchArticles(forKey: bookmarkedArticlesKey)
    }
    
    // Add or update an article
    func addOrUpdateArticle(_ article: Article) {
        var readArticles = fetchReadArticles()
        var bookmarkedArticles = fetchBookmarkedArticles()
        
        // Handle read articles
        if article.isRead ?? false { // provide false as default if nil
            if let index = readArticles.firstIndex(where: { $0.id == article.id }) {
                readArticles[index] = article
            } else {
                readArticles.append(article)
            }
        } else {
            readArticles.removeAll { $0.id == article.id }
        }
        saveReadArticles(readArticles)
        
        // Handle bookmarked articles
        if article.isBookmarked ?? false { // provide false as default if nil
            if let index = bookmarkedArticles.firstIndex(where: { $0.id == article.id }) {
                bookmarkedArticles[index] = article
            } else {
                bookmarkedArticles.append(article)
            }
        } else {
            bookmarkedArticles.removeAll { $0.id == article.id }
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
