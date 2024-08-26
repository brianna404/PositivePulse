//
//  ArticleListView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 19.08.24.
//

import Foundation
import SwiftUI

struct ArticleListView: View {
    let articles: [Article]
    
    @StateObject
    var viewModel = NewsViewModelImpl(service: NewsServiceImpl(), filterService: FilterServiceImpl())
    
    var body: some View {
        ForEach (articles) { article in
            if let urlString = article.url, let url = URL(string: urlString) {
                NavigationLink(
                    destination: ArticleWebView(url: url, article: article) // navigate to URL WebView
                        .navigationTitle(article.title ?? "Article")
                ) { ArticleView(article: article, titleFontSize: 18, iconSize: 20, dateFontSize: 11)
                        .contentShape(Rectangle()) // Make the entire cell tappable
                }
            } else {
                ArticleView(article: article, titleFontSize: 18, iconSize: 20, dateFontSize: 11)
            }
        }
    }
}
