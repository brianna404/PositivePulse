//
//  NewsService.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation
import Combine

// MARK: - NewsService Protocol
protocol NewsService {
    func request(from endpoint: NewsAPI) -> AnyPublisher<NewsResponse, APIError>
}

// MARK: - NewsServiceImpl Class
// Class to implement the NewsService protocol and performs the actual network request
class NewsServiceImpl: NewsService {
    
    // The request method performs a network request to fetch news data
    func request(from endpoint: NewsAPI) -> AnyPublisher<NewsResponse, APIError> {
        // Perform a data task using URLSession's dataTaskPublisher
        return URLSession
            .shared
            // Publish data and response from the URL request
            .dataTaskPublisher(for: endpoint.request)
            // Ensure that updates are received on the main thread
            .receive(on: DispatchQueue.main)
            // Map any error to a generic unknown APIError
            .mapError { _ in APIError.unkown }
            .flatMap { data, response -> AnyPublisher<NewsResponse,APIError> in
                // Ensure the response is an HTTPURLResponse
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: APIError.unkown).eraseToAnyPublisher()
                }
                // Check if the status code indicates success (2xx)
                if (200...299).contains(response.statusCode) {
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
                    return Fail(error: APIError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }
            // Erase the type for external consumption
            .eraseToAnyPublisher()
    }
    
    
}
