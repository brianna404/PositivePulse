//
//  ArticleListView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 19.08.24.
//

import Foundation
import SwiftUI

// MARK: - ArticleListView Struct
// Articles shown as clickable list view

struct ArticleListView: View {
    
    // MARK: - ArticleListView Attributes
    
    // Provided array to hold fetched articles
    let articles: [Article]
    
    // Use AppStorage for setting fontSize of text elements
    @AppStorage("selectedFontSize") private var selectedFontSize = FontSizeState.medium
    
    // Instance of viewModel from observableObject NewsViewModelImp
    @StateObject
    var viewModel = NewsViewModelImpl(service: NewsServiceImpl(), filterService: FilterServiceImpl())
    
    var body: some View {

        // Iterating through array of articles provided
        ForEach (articles) { article in
            
            // Gets URL string of every article
            if let urlString = article.url, let url = URL(string: urlString) {
                
                // Creating navigational link between ArticleListView and ArticleWebView
                NavigationLink(
                    // Navigate to URL WebView
                    destination: ArticleWebView(url: url, article: article)
                    // Show title of article as title on ArticleWebView
                        .navigationTitle(article.title ?? "Article")
                    
                    // ArticleView as clickable object for navigation
                ) { ArticleView(article: article, titleFontSize: selectedFontSize.fontSizeCGFloat["headline"] ?? 17, iconSize: 20, dateFontSize: selectedFontSize.fontSizeCGFloat["caption1"] ?? 12)
                        // Make the entire cell tappable
                        .contentShape(Rectangle())
                }
                
                // If no URL provided show non-clickable ArticleView object
            } else {
                ArticleView(article: article, titleFontSize: selectedFontSize.fontSizeCGFloat["headline"] ?? 17, iconSize: 20, dateFontSize: selectedFontSize.fontSizeCGFloat["caption1"] ?? 12)
            }
        }
    }
}
