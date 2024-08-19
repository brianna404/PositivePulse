//
//  NewsViewModel.swift
//  IOSApp
//
//  Created by Michelle Köhler on 28.07.24.
//

import Foundation
import Combine
import NaturalLanguage

// MARK: - Protocol defining the interface for NewsViewModel
protocol NewsViewModel {
    var articles: [Article] { get }
    var positiveArticles: [Article] { get }
    var state: ResultState { get }
    func getArticles(category: String)
}

// MARK: - Implementation of NewsViewModel
class NewsViewModelImpl: ObservableObject, NewsViewModel {
    private let service: NewsService // Service responsible for fetching news
    private(set) var articles = [Article] () // Array to hold fetched articles
    private var cancellables = Set<AnyCancellable>() // Set to keep track of Combine cancellables
    
    @Published private(set) var positiveArticles = [Article]() // Array to hold positive articles
    @Published private(set) var searchResults = [Article]() // Array to hold result of search
    @Published private(set) var state: ResultState = .loading // Current state of the view model
    @Published var selectedCategory: FilterCategory? = .general { // Selected filter category
        didSet {
                loadNewArticles()
            }
    }
    @Published var selectedCategoryStrg = "general"
    
    var hasFetched = false  // flag to prevent fetching several times
    // Initialization
    init (service: NewsService) {
        self.service = service
    }
    
// MARK: - Methods
    func loadNewArticles() {
        // setting hasFetched to false for loading articles in new api call
        self.hasFetched = false
        self.getArticles(category: self.selectedCategoryStrg)
    }
    
    func getArticles(category: String) {
        // block unused api calls if has fetched
        guard !hasFetched else { return }
        
        self.articles = []
        self.positiveArticles = []
        self.state = .loading // Set state to loading

        // Make a network request using the NewsService
        let cancellable = service
            .request(from: .getNews(category: category)) // Call the getNews endpoint of the service
            .sink { res in // Subscribe to the publisher's output
                switch res {
                case .finished:
                    // if successful update state to success with articles
                    self.state = .success(content: self.articles)
                    // Filter and update positive articles
                    self.positiveArticles = self.service.filterPositiveNews(from: self.articles)
                    //print("Fetching and filtering articles complete. Filtered positive articles count: \(self.positiveArticles.count)")
                    self.hasFetched = true  // Set the flag after successful fetch
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
//    func getFilterValue() -> String {
//       return selectedCategory?.filterValue ?? "general"
//    }
    
    func searchArticles(with keyword: String) {
        self.state = .loading
        
        // Begin a new search with the provided keyword
        let cancellable = service.searchArticles(keyword: keyword)
            .sink { res in
                // Check the result of the publisher
                switch res {
                case .finished:
                    self.state = .success(content: self.searchResults)
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            // When the response is received, update the search results
            } receiveValue: { response in
                self.searchResults = response.articles
            }
        // Store the cancellable to allow for the network request to be cancelled later if needed
        self.cancellables.insert(cancellable)
    }
    
    // Function to clear the search results
    func clearSearchResults() {
        self.searchResults = []
    }
}
