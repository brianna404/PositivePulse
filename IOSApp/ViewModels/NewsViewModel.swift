//
//  NewsViewModel.swift
//  IOSApp
//
//  Created by Michelle Köhler on 28.07.24.
//

import Foundation
import Combine
import NaturalLanguage

// MARK: - NewsViewModel Protocol
// Defines interface for NewaViewModel

protocol NewsViewModel {
    var articles: [Article] { get }
    var positiveArticles: [Article] { get }
    var state: ResultState { get }
    
    func getArticles(category: String?, keyword: String?, country: String?)
}

// MARK: - NewsViewModelImpl Class
// Implementing NewsViewModel

class NewsViewModelImpl: ObservableObject, NewsViewModel {
    
    // Service responsible for fetching news
    private let service: NewsService
    // Service responsible for filtering
    private let filterService: FilterService
    // Array to hold fetched articles
    private(set) var articles = [Article] ()
    // Set to keep track of Combine cancellables
    private var cancellables = Set<AnyCancellable>()
    // Safes if articles loaded for first time
    private var isInitialLoad = true
    // Flag to prevent fetching several times
    private var hasFetched = false
    
    // Array to hold positive articles
    @Published private(set) var positiveArticles = [Article]()
    // Array to hold result of search
    @Published private(set) var searchResults = [Article]()
    // Current state of the view model
    @Published private(set) var state: ResultState = .loading
    // String value for api filter
    @Published var selectedCountryStrg = CountryState.germany.filterValue
    // String value for api filter
    @Published var selectedCategoryStrg = FilterCategoryState.general.filterValue
    // Selected filter category
    @Published var selectedCategory: FilterCategoryState? = .general {
        // If category is set for observed parameter new articles will be loaded
        didSet {
            loadNewArticles(keyword: nil)
        }
    }
    
    // Initialization
    init (service: NewsService, filterService: FilterService) {
        self.service = service
        self.filterService = filterService
    }
    
// MARK: - Methods
    
    // Loads new articles in case of filtering, searching or reloading
    func loadNewArticles(keyword: String? = nil) {
        // Setting hasFetched to false for loading articles in new api call
        self.hasFetched = false
        self.getArticles(category: self.selectedCategoryStrg, keyword: keyword, country: self.selectedCountryStrg)
    }
    
    // Makes api call and gets articles
    func getArticles(category: String?, keyword: String?, country: String?) {
        // Block unused api calls if has fetched
        guard !hasFetched || keyword != nil else { return }
        
        // Reset results
        self.articles = []
        self.positiveArticles = []
        self.searchResults = []
        
        // Only if initial loading of articles, do actions of loading state
        if isInitialLoad {
            self.state = .loading
            isInitialLoad = false
        }
        
        // Make a network request using the NewsService
        let cancellable = service
        
            // Call the getNews endpoint of the service
            .request(from: .getNews(category: category, keyword: keyword, country: selectedCountryStrg))
            // Subscribe to the publisher's output
            .sink { res in
                switch res {
                    
                // If successful update state to success with articles
                case .finished:
                    self.state = .success(content: self.articles)
                    // Filter and update positive articles
                    self.positiveArticles = self.filterService.filterPositiveNews(from: self.articles)
                    // Set the flag after successful fetch
                    self.hasFetched = true
                    
                // If failed update state to failed with error
                case .failure(let error):
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
    
    // Function for searching articles
    func searchArticles(with keyword: String, in category: String?) {
        loadNewArticles(keyword: keyword)
    }
    
    // Function to clear search results
    func clearSearchResults() {
        self.searchResults = []
    }
}
