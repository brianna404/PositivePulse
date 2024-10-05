//
//  NewsService.swift
//  PositivePulse
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation
import Combine

// MARK: - NewsService Protocol

/// Defines the interface for the news fetching service.
protocol NewsService {
    /// Performs a network request to fetch news data from the specified endpoint.
    ///
    /// - Parameter endpoint: The `NewsAPI` endpoint to request data from.
    /// - Returns: A publisher emitting `NewsResponse` on success or `APIError` on failure.
    func request(from endpoint: NewsAPI) -> AnyPublisher<NewsResponse, APIError>
}

// MARK: - NewsServiceImpl Class

/// Implements the `NewsService` protocol to perform actual network requests.
class NewsServiceImpl: NewsService {
    
    /// Performs a network request to fetch news data.
    ///
    /// - Parameter endpoint: The `NewsAPI` endpoint to request data from.
    /// - Returns: A publisher emitting `NewsResponse` on success or `APIError` on failure.
    func request(from endpoint: NewsAPI) -> AnyPublisher<NewsResponse, APIError> {
        
        // Perform a data task using URLSession's dataTaskPublisher
        return URLSession.shared
            .dataTaskPublisher(for: endpoint.request)
            // Ensure that updates are received on the main thread
            .receive(on: DispatchQueue.main)
            // Map any error to a generic unknown APIError
            .mapError { _ in APIError.unknown }
            .flatMap { data, response -> AnyPublisher<NewsResponse, APIError> in
                
                // Ensure the response is an HTTPURLResponse
                guard let httpResponse = response as? HTTPURLResponse else {
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }
                
                // Check if the status code indicates success (2xx)
                if (200...299).contains(httpResponse.statusCode) {
                    
                    // Configure JSONDecoder for decoding dates
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .iso8601
                    
                    // Decode the data into NewsResponse
                    return Just(data)
                        .decode(type: NewsResponse.self, decoder: jsonDecoder)
                        // Map decoding errors to a specific APIError
                        .mapError { _ in APIError.decodingError }
                        .eraseToAnyPublisher()
                    
                } else {
                    // Handle non-success HTTP status codes
                    return Fail(error: APIError.errorCode(httpResponse.statusCode)).eraseToAnyPublisher()
                }
            }
            // Erase the type for external consumption
            .eraseToAnyPublisher()
    }
}
