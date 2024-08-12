//
//  MyPageView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 11.08.24.
//

import SwiftUI

struct MyPageView: View {
    @State private var selectedTab = 0
    private let articleStorage = ArticleStorage()
    
    var body: some View {
        VStack {
            // Tab Selection
            Picker(selection: $selectedTab, label: Text("")) {
                Text("Gemerkt").tag(0)
                Text("Gelesen").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top, 16)
            .padding(.horizontal, 16)
            
            // Tab Views
            if selectedTab == 0 {
                ArticleListView(articles: articleStorage.fetchBookmarkedArticles())
            } else {
                ArticleListView(articles: articleStorage.fetchReadArticles())
            }
        }
    }
}

struct ArticleListView: View {
    let articles: [Article]
    
    var body: some View {
        List(articles) { article in
            ArticleView(article: article)
                .contentShape(Rectangle()) // Make the entire cell tappable
        }
    }
}

#Preview {
    MyPageView()
}
