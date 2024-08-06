//
//  NewsViewModel.swift
//  IOSApp
//
//  Created by Michelle Köhler on 28.07.24.
//

import Foundation
import Combine
import NaturalLanguage

// Protocol defining the interface for NewsViewModel
protocol NewsViewModel {
    func getArticles()
}

// implementation of NewsViewModel
class NewsViewModelImpl: ObservableObject, NewsViewModel {
    private let service: NewsService // Service responsible for fetching news
    private(set) var articles = [Article] () // Array to hold fetched articles
    @Published private(set) var positiveArticles = [Article]() // Array to hold positive articles
    private var cancellables = Set<AnyCancellable>() // Set to keep track of Combine cancellables
    @Published private(set) var state: ResultState = .loading // Current state of the view model
    
    // Initialization
    init (service: NewsService) {
        self.service = service
    }
    
    // methods
    func getArticles() {
        self.state = .loading // Set state to loading
        
        // Make a network request using the NewsService
        let cancellable = service
            .request(from: .getNews) // Call the getNews endpoint of the service
            .sink { res in // Subscribe to the publisher's output
                switch res {
                case .finished:
                    // if successful update state to success with articles
                    self.state = .success(content: self.articles)
                    // Filter and update positive articles
                    self.positiveArticles = self.service.filterPositiveNews(from: self.articles)
                case .failure(let error):
                    // if failed update state to failed with error
                    self.state = .failed(error: error)
                }
            // When receiving a value, update the articles with response articles
            } receiveValue: { response in
                self.articles = response.results
            }
        // Store the cancellable to be able to cancel it if needed
        self.cancellables.insert(cancellable)
    }
}
