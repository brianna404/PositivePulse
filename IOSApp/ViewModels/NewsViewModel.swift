//
//  NewsViewModel.swift
//  IOSApp
//
//  Created by Michelle Köhler on 28.07.24.
//

import Foundation
import Combine
import NaturalLanguage
import SwiftUI

// MARK: - NewsViewModel Protocol

/// Defines the interface for the NewsViewModel.
protocol NewsViewModel {
    /// An array of all fetched articles.
    var articles: [Article] { get }
    
    /// An array of filtered positive articles.
    var positiveArticles: [Article] { get }
    
    /// The current state of the result (loading, success, or failure).
    var state: ResultState { get }
    
    /// Fetches articles based on the provided category, keyword, and country.
    ///
    /// - Parameters:
    ///   - category: The category to filter articles.
    ///   - keyword: The keyword to search articles.
    ///   - country: The country code to filter articles.
    func getArticles(category: FilterCategoryState?, keyword: String?, country: CountryState?)
}

// MARK: - NewsViewModelImpl Class

/// Implements the `NewsViewModel` protocol.
class NewsViewModelImpl: ObservableObject, NewsViewModel {
    
    // MARK: - Properties
    
    /// Service responsible for fetching news.
    private let service: NewsService
    
    /// Service responsible for filtering articles.
    private let filterService: FilterService
    
    /// An array to hold fetched articles.
    private(set) var articles = [Article]()
    
    /// A set to keep track of Combine cancellables.
    private var cancellables = Set<AnyCancellable>()
    
    /// Indicates if articles are loaded for the first time.
    private var isInitialLoad = true
    
    /// Flag to prevent multiple fetches.
    private var hasFetched = false
    
    /// An array to hold positive articles.
    @Published private(set) var positiveArticles = [Article]()
    
    /// An array to hold search results.
    @Published private(set) var searchResults = [Article]()
    
    /// The current state of the view model.
    @Published private(set) var state: ResultState = .loading
    
    /// The selected country filter.
    @AppStorage("selectedCountry") var selectedCountry = CountryState.germany
    
    /// The selected category filter.
    @AppStorage("selectedCategory") var selectedCategory = FilterCategoryState.general
    
    // MARK: - Initialization
    
    /// Initializes the view model with required services.
    ///
    /// - Parameters:
    ///   - service: The news fetching service.
    ///   - filterService: The service responsible for filtering articles.
    init(service: NewsService, filterService: FilterService) {
        self.service = service
        self.filterService = filterService
    }
    
    // MARK: - Methods
    
    /// Loads new articles, optionally filtering by keyword.
    ///
    /// - Parameter keyword: The keyword to search articles.
    func loadNewArticles(keyword: String? = nil) {
        // Reset the fetch flag to allow a new API call
        self.hasFetched = false
        self.getArticles(category: self.selectedCategory, keyword: keyword, country: self.selectedCountry)
    }
    
    /// Makes an API call to fetch articles based on filters.
    ///
    /// - Parameters:
    ///   - category: The category to filter articles.
    ///   - keyword: The keyword to search articles.
    ///   - country: The country code to filter articles.
    func getArticles(category: FilterCategoryState?, keyword: String?, country: CountryState?) {
        // Prevent unnecessary API calls if articles have already been fetched and no keyword is provided
        guard !hasFetched || keyword != nil else { return }
        
        // Reset article arrays
        self.articles = []
        self.positiveArticles = []
        self.searchResults = []
        
        // Update state to loading only on initial load
        if isInitialLoad {
            self.state = .loading
            isInitialLoad = false
        }
        
        // Make a network request using the NewsService
        let cancellable = service
            .request(from: .getNews(category: category?.filterValue, keyword: keyword, country: selectedCountry.filterValue))
            .sink { res in
                switch res {
                case .finished:
                    if !self.articles.isEmpty {
                        self.state = .success(content: self.articles)
                        // Filter and update positive articles
                        self.positiveArticles = self.filterService.filterPositiveNews(from: self.articles)
                        // Set the fetch flag after successful fetch
                        self.hasFetched = true
                    } else {
                        self.state = .failed(error: APIError.noArticles)
                    }
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { response in
                self.articles = response.articles
                if let keyword = keyword, !keyword.isEmpty {
                    self.searchResults = response.articles
                }
            }
        
        // Store the cancellable to manage the subscription lifecycle
        self.cancellables.insert(cancellable)
    }
    
    /// Searches articles based on a keyword and an optional category.
    ///
    /// - Parameters:
    ///   - keyword: The keyword to search articles.
    ///   - category: The category to filter articles.
    func searchArticles(with keyword: String, in category: String?) {
        if category == nil {
            searchInAllCategories(with: keyword)
        } else {
            loadNewArticles(keyword: keyword)
        }
    }
    
    /// Searches articles across all categories for a given keyword.
    ///
    /// - Parameter keyword: The keyword to search articles.
    func searchInAllCategories(with keyword: String) {
        // Reset search results
        self.searchResults = []
        
        // Get all categories except 'All'
        let categories = FilterCategoryState.allCases.filter { $0 != .all }
        
        // Create a DispatchGroup to synchronize asynchronous network requests
        let group = DispatchGroup()
        
        // Iterate over each category and fetch articles
        for category in categories {
            group.enter()
            
            service
                .request(from: .getNews(category: category.filterValue, keyword: keyword, country: selectedCountry.filterValue))
                .sink { res in
                    switch res {
                    case .finished:
                        group.leave()
                    case .failure(let error):
                        print("Error fetching news for \(category.rawValue): \(error)")
                        group.leave()
                    }
                } receiveValue: { response in
                    DispatchQueue.main.async {
                        self.searchResults.append(contentsOf: response.articles)
                    }
                }
                .store(in: &cancellables)
        }
        
        // Notify when all requests are completed
        group.notify(queue: .main) {
            if self.searchResults.isEmpty {
                self.state = .failed(error: APIError.noArticles)
            } else {
                self.state = .success(content: self.searchResults)
            }
        }
    }
    
    /// Clears the current search results.
    func clearSearchResults() {
        self.searchResults = []
    }
}
