//
//  ArticleWebView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 16.08.24.
//

import Foundation
import SwiftUI
import WebKit

// MARK: - ArticleWebView Struct
// UIViewRepresentable for displaying UIKit Component WKWebView in SwiftUI view

struct ArticleWebView: UIViewRepresentable {
    
    // MARK: - ArticleWebView Attributes
    let url: URL
    let article: Article
    
    // Observe article storage for read articles
    @ObservedObject var articleStorage = ArticleStorageService.shared

    // MARK: - ArticleWebView Methods
    // Creates WKWebView instance to show web content in SwiftUI view
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    // Loads webpage with instance WKWebView and shows context of provided URL
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Uses provided URL for making web URLRequest
        let request = URLRequest(url: url)
        uiView.load(request)
        
        // Mark article as read
        articleStorage.markArticleAsRead(article)
    }
}
