//
//  ArticleWebView.swift
//  PositivePulse
//
//  Created by Michelle Köhler on 16.08.24.
//

import SwiftUI
import WebKit

/// Displays a web view of the article's URL using `WKWebView`.
struct ArticleWebView: UIViewRepresentable {
    
    /// The URL of the article to display.
    let url: URL
    /// The article being viewed.
    let article: Article
    
    /// Observed article storage for tracking read articles.
    @ObservedObject var articleStorage = ArticleStorageService.shared

    /// Creates the `WKWebView` instance.
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    /// Updates the `WKWebView` with the provided URL.
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
        
        // Mark the article as read.
        articleStorage.markArticleAsRead(article)
    }
}
