//
//  SearchView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 11.08.24.
//

import SwiftUI

struct CategoryBoxView: View {
    @ObservedObject var viewModel: NewsViewModelImpl
    
    // create two columns with flexible size for grid layout
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // Category grid boxes
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) { // vertical grid
            ForEach(FilterCategory.allCases, id: \.self) { category in // loop through all categories
                Button(action: {
                    // update selected category when box is clicked
                    viewModel.selectedCategoryStrg = category.filterValue
                    viewModel.selectedCategory = category
                }) {
                    // display category name on box/button
                    Text(category.rawValue)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .background(viewModel.selectedCategory == category ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
        }
        .padding()
    }
}

struct SearchView: View {
    @ObservedObject var articleStorage = ArticleStorage() // to track bookmarked status of articles
    @State private var searchText = "" // Holds the current search text
    @State private var searchResults: [Article] = [] // Stores the search results
    @StateObject private var viewModel = NewsViewModelImpl(service: NewsServiceImpl()) // ViewModel to handle the search logic
    @FocusState private var isFocused: Bool // Tracks whether the search bar is focused (keyboard is open)
    @State private var searchExecuted = false // Tracks whether a search has been executed
    @State private var keyboardHeight: CGFloat = 0 // Tracks the height of the keyboard
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Search Bar
                TextField("Suchen...", text: $searchText, onCommit: {
                    if !searchText.isEmpty { // only execute if searchText is not empty
                        viewModel.searchArticles(with: searchText, in: viewModel.selectedCategoryStrg)
                        searchExecuted = true
                    }
                })
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .focused($isFocused) // Bind the focus state to the search bar
                
                // Show the selected category after search is committed
                if searchExecuted && !searchText.isEmpty {
                    Text("in \(viewModel.selectedCategory?.rawValue ?? "Allgemein")")
                        .foregroundColor(.gray)
                        .font(.footnote) // Make the font smaller
                        .padding(.top, 3)
                        .frame(alignment: .leading)
                }
                
                // Category Filter Boxes
                if !searchExecuted || searchText.isEmpty {
                    CategoryBoxView(viewModel: viewModel)
                        .padding(.top, 16)
                }
                
                // Search Results or No Results Info
                if searchExecuted && !searchResults.isEmpty && !searchText.isEmpty {
                    // Display the search results
                    List(viewModel.searchResults) { article in
                        ArticleView(article: article)
                    }
                } else if searchExecuted && searchExecuted && !searchText.isEmpty {
                    // Display an info message when no results are found
                    Text("Keine Ergebnisse gefunden.")
                        .foregroundColor(.gray)
                        .padding()
                }
                Spacer()
            }
            
            // reset search view
            .onChange(of: searchText) {
                if searchText.isEmpty {
                    viewModel.clearSearchResults()
                    searchExecuted = false
                }
            }
            
            // close keyboard when clicking outside
            .onTapGesture {
                isFocused = false
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
                        keyboardHeight = keyboardFrame.height - geometry.safeAreaInsets.bottom
                    }
                }
                
                // when keyboard is about to be hidden
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    // set keyboard height to 0
                    keyboardHeight = 0
                }
            }
            .padding(.bottom, keyboardHeight) // Adjust the view's bottom padding by the keyboard height
            .animation(.easeOut(duration: 0.16), value: keyboardHeight) // Smooth animation when the keyboard appears/disappears
            }
        }
    }
    
    #Preview {
        SearchView()
    }
