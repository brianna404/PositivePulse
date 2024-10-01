//
//  FilterService.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 26.08.24.
//

import Foundation
import NaturalLanguage

/// Protocol defining the filter service interface.
protocol FilterService {
    /// Filters positive news articles from a given list.
    ///
    /// - Parameter articles: The list of articles to filter.
    /// - Returns: An array of articles with positive sentiment.
    func filterPositiveNews(from articles: [Article]) -> [Article]
}

/// Implementation of the FilterService protocol.
class FilterServiceImpl: FilterService {
    
    /// Performs sentiment analysis on a given text.
    ///
    /// - Parameter text: The text to analyze.
    /// - Returns: A sentiment score between -1.0 and 1.0.
    func analyzeSentiment(for text: String) -> Double? {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        
        // Set language to German
        tagger.setLanguage(.german, range: text.startIndex..<text.endIndex)
        
        // Get sentiment score
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        var score = sentiment.flatMap { Double($0.rawValue) } ?? 0.0 // Convert to Double or default to 0.0
        
        let lowercasedText = text.lowercased()
        
        // Check for negative keywords
        for keyword in NegativeKeywords.list {
            if lowercasedText.contains(keyword) {
                score = min(score, -0.5) // Set score to at least -0.5
            }
        }
        
        return score
    }
    
    /// Filters positive news articles from a list.
    ///
    /// - Parameter articles: The list of articles to filter.
    /// - Returns: An array of articles with positive sentiment.
    func filterPositiveNews(from articles: [Article]) -> [Article] {
        return articles.filter { article in
            if let title = article.title, let score = analyzeSentiment(for: title) {
                return score > 0 // Only positive scores
            }
            return false
        }
    }
}
