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
    var articles: [Article] { get }
    var positiveArticles: [Article] { get }
    var state: ResultState { get }
    func getArticles()
}

// implementation of NewsViewModel
class NewsViewModelImpl: ObservableObject, NewsViewModel {
    private let service: NewsService // Service responsible for fetching news
    private(set) var articles = [Article] () // Array to hold fetched articles
    private var cancellables = Set<AnyCancellable>() // Set to keep track of Combine cancellables
    
    @Published private(set) var positiveArticles = [Article]() // Array to hold positive articles
    @Published private(set) var state: ResultState = .loading // Current state of the view model
    
    var hasFetched = false  // flag to prevent fetching several times
    // Initialization
    init (service: NewsService) {
        self.service = service
    }
    
    // methods
    func getArticles() {
        // Prevent multiple fetches
        guard !hasFetched else { return }
        
        self.state = .loading // Set state to loading
        hasFetched = true  // Set the flag

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
                    print("Fetching and filtering articles complete. Filtered positive articles count: \(self.positiveArticles.count)")
                case .failure(let error):
                    // if failed update state to failed with error
                    self.state = .failed(error: error)
                }
            // When receiving a value, update the articles with response articles
            } receiveValue: { response in
                self.articles = response.articles
            }
        // Store the cancellable to be able to cancel it if needed
        self.cancellables.insert(cancellable)
    }
}
