//
//  ArticleWebView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 16.08.24.
//

import Foundation
import SwiftUI
import WebKit

struct ArticleWebView: UIViewRepresentable {
    let url: URL
    let article: Article
    @ObservedObject var articleStorage = ArticleStorage()

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
        
        // Mark article as read
        articleStorage.markArticleAsRead(article)
    }
}
