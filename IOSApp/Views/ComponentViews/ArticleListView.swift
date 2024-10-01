//
//  ArticleListView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 19.08.24.
//

import SwiftUI

/// Displays articles as a clickable list view.
struct ArticleListView: View {
    
    /// The array of fetched articles to display.
    let articles: [Article]
    
    /// Selected font size for text elements.
    @AppStorage("selectedFontSize") private var selectedFontSize = FontSizeState.medium
    
    /// View model instance.
    @StateObject var viewModel = NewsViewModelImpl(service: NewsServiceImpl(), filterService: FilterServiceImpl())
    
    var body: some View {
        // Iterate through the provided articles.
        ForEach(articles) { article in
            // Check if the article has a valid URL.
            if let urlString = article.url, let url = URL(string: urlString) {
                // Create a navigation link to the article's web view.
                NavigationLink(
                    destination: ArticleWebView(url: url, article: article)
                        .navigationTitle(article.title ?? "Article")
                ) {
                    // Display the article view.
                    ArticleView(
                        article: article,
                        titleFontSize: selectedFontSize.fontSizeCGFloat["headline"] ?? 17,
                        iconSize: 20,
                        dateFontSize: selectedFontSize.fontSizeCGFloat["caption1"] ?? 12
                    )
                    .contentShape(Rectangle()) // Make the entire cell tappable.
                }
            } else {
                // Display a non-clickable article view if no URL is provided.
                ArticleView(
                    article: article,
                    titleFontSize: selectedFontSize.fontSizeCGFloat["headline"] ?? 17,
                    iconSize: 20,
                    dateFontSize: selectedFontSize.fontSizeCGFloat["caption1"] ?? 12
                )
            }
        }
    }
}
