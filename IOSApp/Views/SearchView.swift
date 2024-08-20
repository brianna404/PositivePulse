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
    @State private var searchText = "" // Holds the current search text
    @State private var searchResults: [Article] = [] // Stores the search results
    @StateObject private var viewModel = NewsViewModelImpl(service: NewsServiceImpl()) // ViewModel to handle the search logic
    @FocusState private var isFocused: Bool // Tracks whether the search bar is focused (keyboard is open)
    @State private var searchExecuted = false // Tracks whether a search has been executed

    var body: some View {
        VStack {
            // Search Bar
            TextField("Suchen...", text: $searchText, onCommit: {
                viewModel.searchArticles(with: searchText, in: viewModel.selectedCategoryStrg)
                searchExecuted = true
            })
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            .focused($isFocused) // Bind the focus state to the search bar
            
            // Show the selected category after search is committed
            if searchExecuted {
                Text("in \(viewModel.selectedCategory?.rawValue ?? "Allgemein")")
                    .foregroundColor(.gray)
                    .font(.footnote) // Make the font smaller
                    .padding(.top, 3)
                    .frame(alignment: .leading)
            }

            // Category Filter Boxes
            if !searchExecuted {
                CategoryBoxView(viewModel: viewModel)
                    .padding(.top, 16)
            }
            
            // Search Results or No Results Info
            if !searchResults.isEmpty {
                // Display the search results
                List(viewModel.searchResults) { article in
                    ArticleView(article: article)
                }
            } else if searchExecuted && !searchText.isEmpty {
                // Display an info message when no results are found
                Text("Keine Ergebnisse gefunden.")
                    .foregroundColor(.gray)
                    .padding()
            }
            Spacer()
        }
        .onChange(of: searchText) {
            if searchText.isEmpty {
                viewModel.clearSearchResults()
                searchExecuted = false
            }
        }
        .onTapGesture {
            isFocused = false // close keyboard when clicking outside
        }
        .onReceive(viewModel.$searchResults) { results in
            // Update local searchResults when viewModel updates
            self.searchResults = results
            print("Search results updated: \(results.count) articles found.")
        }
    }
}

#Preview {
    SearchView()
}
