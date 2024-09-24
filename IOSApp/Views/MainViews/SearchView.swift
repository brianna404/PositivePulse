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
    @State private var searchExecuted = false // Tracks whether a search has been executed
    @State private var keyboardHeight: CGFloat = 0 // Tracks the height of the keyboard
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    // Search Bar
                    TextField("Suchen...", text: $searchText, onCommit: {
                        if !searchText.isEmpty { // only execute if searchText is not empty
                            viewModel.searchArticles(with: searchText, in: viewModel.selectedCategory.filterValue)
                            searchExecuted = true
                        }
                    })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .shadow(color: .gray, radius: 4, x: 0, y: 2)
                    .focused($isFocused) // Bind the focus state to the search bar
                    
                    .onTapGesture {
                        searchExecuted = false
                    }
                    
                    // Show the selected category after search is committed
                    if searchExecuted && !searchText.isEmpty {
                        Text("in \(viewModel.selectedCategory.rawValue)")
                            .foregroundColor(.gray)
                            .font(.system(size: selectedFontSize.fontSizeCGFloat["foodnote"] ?? 13)) // Make the font smaller
                            .padding(.top, 3)
                            .frame(alignment: .leading)
                    }
                    
                    // Category Filter Boxes
                    if !searchExecuted || searchText.isEmpty {
                        CategoryBoxView(viewModel: viewModel)
                            .padding(.top, 16)
                    }
                    
                    // If search is executed, then show different cases (loading, error, success)
                    if searchExecuted {
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
                                ErrorView(error: error) {
                                    viewModel.searchArticles(with: searchText, in: viewModel.selectedCategory.filterValue)
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
                .padding(.top, keyboardHeight + 15) // Adjust the view's top padding by the keyboard height
                
                // reset search view
                .onChange(of: searchText) {
                    if searchText.isEmpty {
                        viewModel.clearSearchResults()
                    }
                }
                
                // Update local searchResults when viewModel updates
                .onReceive(viewModel.$searchResults) { results in
                    self.searchResults = results
                }
                
                // handle display of keyboard
                .onAppear {
                    // when keyboard is about to be shown
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                        // if keyboard is shown get its height
                        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            keyboardHeight = keyboardFrame.height
                        }
                    }
                    
                    // when keyboard is about to be hidden
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                        // set keyboard height to 0
                        keyboardHeight = 0
                    }
                }
                .animation(.easeOut(duration: 0.16), value: keyboardHeight) // Smooth animation when the keyboard appears/disappears
            }
        }
    }
}

#Preview {
    SearchView()
}
