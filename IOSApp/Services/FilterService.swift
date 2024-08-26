//
//  FilterService.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 26.08.24.
//

import Foundation
import NaturalLanguage

protocol FilterService {
    func filterPositiveNews(from articles: [Article]) -> [Article]
}

class FilterServiceImpl: FilterService {
    
    // Function to perform sentiment analysis on a given text
    func analyzeSentiment(for text: String) -> Double? {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        
        // Set the language to German
        tagger.setLanguage(.german, range: text.startIndex..<text.endIndex)
        
        // Get the sentiment score for the text
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        var score = sentiment.flatMap { Double($0.rawValue) } ?? 0.0 // convert sentiment string to double if possible, else use 0.0
        
        let lowercasedText = text.lowercased()
        
        // check if negative keyword is in text
        for keyword in NegativeKeywords.list {
            if lowercasedText.contains(keyword) {
                // if found set score to a negative value
                score = min(score, -0.5) // if bigger than -0,5 set score to -0,5
            }
        }
        
        return score
    }
    
    // Function to filter positive news from a list of articles
    func filterPositiveNews(from articles: [Article]) -> [Article] {
        return articles.filter { article in
            // Analyze the sentiment of the article title and filter if positive
            if let title = article.title, let score = analyzeSentiment(for: title) {
                return score > 0 // score from -1 (negative) to 1 (positive), -> 0 is neutral
            }
            return false
        }
    }
}
