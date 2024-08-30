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
    func getArticles(category: String?, keyword: String?, country: String?)
}

// MARK: - Implementation of NewsViewModel
class NewsViewModelImpl: ObservableObject, NewsViewModel {
    private let service: NewsService // Service responsible for fetching news
    private let filterService: FilterService // Service responsible for filtering
    private(set) var articles = [Article] () // Array to hold fetched articles
    private var cancellables = Set<AnyCancellable>() // Set to keep track of Combine cancellables
    private var isInitialLoad = true // safes if articles loaded for first time
    
    @Published private(set) var positiveArticles = [Article]() // Array to hold positive articles
    @Published private(set) var searchResults = [Article]() // Array to hold result of search
    @Published private(set) var state: ResultState = .loading // Current state of the view model
    @Published var selectedCategory: FilterCategoryState? = .general { // Selected filter category
        didSet {
            loadNewArticles(keyword: nil)
        }
    }
    @Published var selectedCategoryStrg = "general"
    @Published var selectedCountryStrg = CountryState.germany.filterValue
    
    var hasFetched = false  // flag to prevent fetching several times
    
    // Initialization
    init (service: NewsService, filterService: FilterService) {
        self.service = service
        self.filterService = filterService
    }
    
    // MARK: - Methods
    func loadNewArticles(keyword: String? = nil) {
        // setting hasFetched to false for loading articles in new api call
        self.hasFetched = false
        self.getArticles(category: self.selectedCategoryStrg, keyword: keyword, country: self.selectedCountryStrg)
    }
    
    func getArticles(category: String?, keyword: String?, country: String?) {
        // block unused api calls if has fetched
        guard !hasFetched || keyword != nil else { return }
        
        // reset results
        self.articles = []
        self.positiveArticles = []
        self.searchResults = []
        
        if isInitialLoad {
            self.state = .loading // Set state to loading
            isInitialLoad = false
        }
        
        // Make a network request using the NewsService
        let cancellable = service
            .request(from: .getNews(category: category, keyword: keyword, country: selectedCountryStrg)) // Call the getNews endpoint of the service
            .sink { res in // Subscribe to the publisher's output
                switch res {
                case .finished:
                    // if successful update state to success with articles
                    self.state = .success(content: self.articles)
                    // Filter and update positive articles
                    self.positiveArticles = self.filterService.filterPositiveNews(from: self.articles)
                    self.hasFetched = true  // Set the flag after successful fetch
                case .failure(let error):
                    // if failed update state to failed with error
                    self.state = .failed(error: error)
                }
                // When receiving a value, update the articles with response articles
            } receiveValue: { response in
                self.articles = response.articles
                if keyword != nil && !keyword!.isEmpty {
                    self.searchResults = response.articles
                }
            }
        // Store the cancellable to be able to cancel it if needed
        self.cancellables.insert(cancellable)
    }
    
    // function for searching articles
    func searchArticles(with keyword: String, in category: String?) {
        loadNewArticles(keyword: keyword)
    }
    
    // function to clear search results
    func clearSearchResults() {
        self.searchResults = []
    }
}
