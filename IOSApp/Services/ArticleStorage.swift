//
//  ArticleStorage.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 06.08.24.
//

import Foundation

class ArticleStorage: ObservableObject {
    // define keys for sets
    private let readArticlesKey = "readArticles"
    private let bookmarkedArticlesKey = "bookmarkedArticles"
    
    // published bookmarked articles for bug fixing 
    @Published private(set) var bookmarkedArticles: Set<Article> = []

    init() {
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
    
    // Update logic when an article is read
    func markArticleAsRead(_ article: Article) {
        let updatedArticle = article
        updatedArticle.isRead = true
        updatedArticle.lastRead = Date()
        addOrUpdateArticle(updatedArticle)
    }
    
    // Toggle the bookmark status of an article
    func toggleBookmark(for article: Article) -> Article {
        let updatedArticle = article
        updatedArticle.isBookmarked = !(article.isBookmarked ?? false) // update bookmark status
        updatedArticle.lastBookmarked = updatedArticle.isBookmarked ?? false ? Date() : nil // Set or clear lastBookmarked date
        addOrUpdateArticle(updatedArticle)
        return updatedArticle
    }
}
