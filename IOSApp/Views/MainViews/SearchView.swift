//
//  SearchView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 11.08.24.
//

import SwiftUI

struct SearchView: View {
    // Use AppStorage for setting fontSize of text elements 
    @AppStorage("selectedFontSize") private var selectedFontSize = FontSizeState.medium
    @State private var searchText = "" // Holds the current search text
    @State private var searchResults: [Article] = [] // Stores the search results
    @StateObject private var viewModel = NewsViewModelImpl(service: NewsServiceImpl(), filterService: FilterServiceImpl()) // ViewModel to handle the search logic
    @FocusState private var isFocused: Bool // Tracks whether the search bar is focused (keyboard is open)
    @State private var searchCommitted = false // Tracks whether a search has been executed
    @State private var keyboardHeight: CGFloat = 0 // Tracks the keyboard height
    @State private var isFirstLaunch = true // Tracks if the app is launched for the first time

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    // Search Bar
                    ZStack{
                        TextField("Suchen...", text: $searchText, onCommit: {
                            if !searchText.isEmpty { // only execute if searchText is not empty
                                viewModel.searchArticles(with: searchText, in: viewModel.selectedCategory.filterValue)
                                searchCommitted = true
                            }
                        })
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .shadow(color: .gray, radius: 4, x: 0, y: 2)
                        .focused($isFocused) // Bind the focus state to the search bar
                        
                        // Show Clear Button (X) if searchText is not empty
                        HStack {
                            Spacer()
                            if isFocused && !searchText.isEmpty {
                                Button(action: {
                                    searchText = "" // Clear search text
                                    searchCommitted = false // Reset search
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing, 25) // right padding
                            }
                        }
                    }
                    
                    // Show the selected category after search is committed
                    if searchCommitted && !searchText.isEmpty {
                        Text("in \(viewModel.selectedCategory.rawValue)")
                            .foregroundColor(.gray)
                            .font(.system(size: selectedFontSize.fontSizeCGFloat["foodnote"] ?? 13)) // Make the font smaller
                            .padding(.top, 3)
                            .frame(alignment: .leading)
                    }
                    
                    // Category Filter Boxes
                    if !searchCommitted || searchText.isEmpty {
                        CategoryBoxView(viewModel: viewModel, searchText: $searchText)
                            .padding(.top, 16)
                    }
                    
                    // If search is executed, then show different cases (loading, error, success)
                    if searchCommitted {
                        Group {
                            switch viewModel.state {
                            // Show a loading indicator while search is in progress
                            case .loading:
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(2)
                                    .padding()
                                
                            // Show the ErrorView in case of a failure
                            case .failed(error: let error):
                                if !isFocused {
                                    ErrorView(error: error, searchCommitted: searchCommitted) {
                                        viewModel.searchArticles(with: searchText, in: viewModel.selectedCategory.filterValue)}
                                }
                                
                            // Show search results when API call is successful
                            case .success:
                                if !searchResults.isEmpty {
                                    List {
                                        ArticleListView(articles: viewModel.searchResults, viewModel: viewModel)
                                    }
                                } else {
                                    // If there are no results
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
                .padding(.bottom, keyboardHeight == 0 ? 0 : -200) // Add negative padding when keyboard is visible
                .ignoresSafeArea(.keyboard, edges: .bottom) // Avoid content shifting when keyboard appears

                // reset search view
                .onChange(of: searchText) {
                    if searchText.isEmpty {
                        viewModel.clearSearchResults()
                        searchCommitted = false
                    }
                }
                
                // Update local searchResults when viewModel updates
                .onReceive(viewModel.$searchResults) { results in
                    self.searchResults = results
                }
                .onAppear {
                    // Set the category to "All" only on first launch
                    if isFirstLaunch {
                        viewModel.selectedCategory = .all
                        isFirstLaunch = false
                    }
                    
                    // Subscribe to keyboard notifications
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            self.keyboardHeight = keyboardFrame.height
                        }
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { _ in
                        self.keyboardHeight = 0
                    }
                }
                .onDisappear {
                    // Remove observers when the view disappears
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
