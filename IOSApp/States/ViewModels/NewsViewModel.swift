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
        func getInitialArticles()
        func loadAndCheckMoreArticles()
}

// implementation of NewsViewModel
class NewsViewModelImpl: ObservableObject, NewsViewModel {
    private let service: NewsService // Service responsible for fetching news
    private(set) var articles = [Article] () // Array to hold fetched articles
    private var cancellables = Set<AnyCancellable>() // Set to keep track of Combine cancellables
    private var nextPage: String? // Safe page number
    
    @Published private(set) var positiveArticles = [Article]() // Array to hold positive articles
    @Published private(set) var state: ResultState = .loading // Current state of the view model
    
    // Initialization
    init (service: NewsService) {
        self.service = service
    }
    
    // methods
    func getInitialArticles() {
        self.articles.removeAll()
        self.positiveArticles.removeAll()
        self.nextPage = nil
        self.getArticles(pageNr: nil)
    }
    
    func getArticles(pageNr: String?) {
        self.state = .loading // Set state to loading
        
        let endpoint: NewsAPI = pageNr == nil ? .getNews : .getMoreNews(pageNr: pageNr!) // depending on nil value or non-nil-value which function tp call
        
        // Make a network request using the NewsService
        let cancellable = service
            .request(from: endpoint) // Call the endpoint of the service
            .sink { res in // Subscribe to the publisher's output
                switch res {
                case .finished:
                    // if successful update state to success with articles
                    self.state = .success(content: self.articles)
                    
                    // Filter and update positive articles
                    let filteredPositiveArticles = self.service.filterPositiveNews(from: self.articles)
                    // add new filtered positve articles to existing positive articles
                    self.positiveArticles.append(contentsOf: filteredPositiveArticles)
                    
                    // check if min 10 positive articles are returned if not load more to filter
                    if self.positiveArticles.count < 10, self.nextPage != nil {
                        self.loadAndCheckMoreArticles()
                    } else {
                        self.state = .success(content: self.positiveArticles)
                    }
                case .failure(let error):
                    // if failed update state to failed with error
                    self.state = .failed(error: error)
                }
            // When receiving a value, update the articles with response articles
            } receiveValue: { response in
                self.articles.append(contentsOf: response.results)
                self.nextPage = response.nextPage // Store the next page number from the response
            }
        // Store the cancellable to be able to cancel it if needed
        self.cancellables.insert(cancellable)
    }
    
    func loadMoreArticles() {
        guard let nextPage = nextPage else { return }
                getArticles(pageNr: nextPage)
    }
    
    func loadAndCheckMoreArticles() {
            var loadedPositiveArticles = 0
            self.articles.removeAll() // Clear previous articles to avoid duplicates
            
            repeat {
                loadMoreArticles()
                loadedPositiveArticles = self.service.filterPositiveNews(from: self.articles).count
            } while positiveArticles.count < 10 && loadedPositiveArticles > 0
        }
}
