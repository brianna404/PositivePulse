//
//  SearchView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 11.08.24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = "" // Holds the current search text
    @State private var searchResults: [Article] = [] // Stores the search results
    @StateObject private var viewModel = NewsViewModelImpl(service: NewsServiceImpl()) // ViewModel to handle the search logic
    @FocusState private var isFocused: Bool // Tracks whether the search bar is focused (keyboard is open)

    var body: some View {
        VStack {
            // Search Bar
            TextField("Suchen...", text: $searchText, onCommit: {
                viewModel.searchArticles(with: searchText)
            })
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            .focused($isFocused) // Bind the focus state to the search bar

            // Search Results or No Results Info
            if !searchResults.isEmpty {
                // Display the search results
                List(viewModel.searchResults) { article in
                    ArticleView(article: article)
                }
            } else if !searchText.isEmpty {
                // Display an info message when no results are found
                Text("Keine Ergebnisse gefunden.")
                    .foregroundColor(.gray)
                    .padding()
            }
            Spacer()
        }
        .onChange(of: searchText) { newValue in
            if newValue.isEmpty {
                viewModel.clearSearchResults()
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
