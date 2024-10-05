//
//  SearchView.swift
//  PositivePulse
//
//  Created by Brianna Kruschke on 11.08.24.
//

import SwiftUI

/// Provides a search interface for users to find articles.
struct SearchView: View {
    /// Selected font size for text elements.
    @AppStorage("selectedFontSize") private var selectedFontSize = FontSizeState.medium
    @State private var searchText = "" // Holds the current search text.
    @State private var searchResults: [Article] = [] // Stores the search results.
    /// View model to handle the search logic.
    @StateObject private var viewModel = NewsViewModelImpl(service: NewsServiceImpl(), filterService: FilterServiceImpl())
    /// Tracks whether the search bar is focused (keyboard is open).
    @FocusState private var isFocused: Bool
    /// Tracks whether a search has been executed.
    @State private var searchCommitted = false
    /// Tracks the keyboard height.
    @State private var keyboardHeight: CGFloat = 0
    /// Tracks if the app is launched for the first time.
    @State private var isFirstLaunch = true

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    // Search Bar
                    ZStack {
                        TextField("Suchen...", text: $searchText, onCommit: {
                            if !searchText.isEmpty {
                                viewModel.searchArticles(with: searchText, in: viewModel.selectedCategory.filterValue)
                                searchCommitted = true
                            }
                        })
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .shadow(color: .gray, radius: 4, x: 0, y: 2)
                        .focused($isFocused)
                        
                        // Clear Button
                        HStack {
                            Spacer()
                            if isFocused && !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                    searchCommitted = false
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing, 25)
                            }
                        }
                    }
                    
                    // Display selected category after search is committed.
                    if searchCommitted && !searchText.isEmpty {
                        Text("in \(viewModel.selectedCategory.rawValue)")
                            .foregroundColor(.gray)
                            .font(.system(size: selectedFontSize.fontSizeCGFloat["footnote"] ?? 13))
                            .padding(.top, 3)
                            .frame(alignment: .leading)
                    }
                    
                    // Category Filter Boxes
                    if !searchCommitted || searchText.isEmpty {
                        CategoryBoxView(viewModel: viewModel, searchText: $searchText)
                            .padding(.top, 16)
                    }
                    
                    // Search Results
                    if searchCommitted {
                        Group {
                            switch viewModel.state {
                            case .loading:
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(2)
                                    .padding()
                                    
                            case .failed(error: let error):
                                if !isFocused {
                                    ErrorView(error: error, searchCommitted: searchCommitted) {
                                        viewModel.searchArticles(with: searchText, in: viewModel.selectedCategory.filterValue)
                                    }
                                }
                                    
                            case .success:
                                if !searchResults.isEmpty {
                                    List {
                                        ArticleListView(articles: viewModel.searchResults, viewModel: viewModel)
                                    }
                                } else {
                                    Text("Keine Ergebnisse gefunden.")
                                        .foregroundColor(.gray)
                                        .padding()
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.top, 15)
                .padding(.bottom, keyboardHeight == 0 ? 0 : -200)
                .ignoresSafeArea(.keyboard, edges: .bottom)

                // Reset search view when search text changes.
                .onChange(of: searchText) { _ in
                    if searchText.isEmpty {
                        viewModel.clearSearchResults()
                        searchCommitted = false
                    }
                }
                
                // Update local searchResults when viewModel updates.
                .onReceive(viewModel.$searchResults) { results in
                    self.searchResults = results
                }
                
                .onAppear {
                    // Set the category to "All" only on first launch.
                    if isFirstLaunch {
                        viewModel.selectedCategory = .all
                        isFirstLaunch = false
                    }
                    
                    // Subscribe to keyboard notifications.
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            self.keyboardHeight = keyboardFrame.height
                        }
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { _ in
                        self.keyboardHeight = 0
                    }
                }
                
                // Remove observers when the view disappears.
                .onDisappear {
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
