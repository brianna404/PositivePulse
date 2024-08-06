//
//  NewsService.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation
import Combine
import NaturalLanguage

// MARK: - NewsService Protocol
protocol NewsService {
    func request(from endpoint: NewsAPI) -> AnyPublisher<NewsResponse, APIError>
    func filterPositiveNews(from articles: [Article]) -> [Article]
}

// MARK: - NewsServiceImpl Class
// class to implement the NewsService protocol and performs the actual network request
class NewsServiceImpl: NewsService {
    
    // the request method performs a network request to fetch news data
    func request(from endpoint: NewsAPI) -> AnyPublisher<NewsResponse, APIError> {
        // perform a data task using URLSession's dataTaskPublisher
        return URLSession
            .shared
            .dataTaskPublisher(for: endpoint.request) // publish data and response from the URL request
            .receive(on: DispatchQueue.main) // ensure that updates are received on the main thread
            .mapError { _ in APIError.unkown } // map any error to a generic unknown APIError
            .flatMap { data, response -> AnyPublisher<NewsResponse,APIError> in
                // ensure the response is an HTTPURLResponse
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: APIError.unkown).eraseToAnyPublisher()
                }
                // check if the status code indicates success (2xx)
                if (200...299).contains(response.statusCode) {
                    // configure JSONDecoder for decoding dates
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .iso8601
                    // decode the data into NewsResponse
                    return Just(data)
                        .decode(type: NewsResponse.self, decoder: jsonDecoder)
                        .mapError { _ in APIError.decodingError } // map decoding errors to a specific APIError
                        .eraseToAnyPublisher()
                } else {
                    // handle non-success HTTP status codes
                    return Fail(error: APIError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher() // erase the type for external consumption
    }
    // Function to perform sentiment analysis on a given text
    func analyzeSentiment(for text: String) -> Double? {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text

        // Get the sentiment score for the text
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        if let sentimentValue = sentiment?.rawValue, let score = Double(sentimentValue) {
            return score
        }
        return nil
    }

    // Function to filter positive news from a list of articles
    func filterPositiveNews(from articles: [Article]) -> [Article] {
        return articles.filter { article in
            // Analyze the sentiment of the article title and filter if positive
            if let description = article.description, let score = analyzeSentiment(for: description) {
                return score > 0
            }
            return false
        }
    }
}
