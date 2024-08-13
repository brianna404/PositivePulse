//
//  MyPageView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 11.08.24.
//

import SwiftUI

struct MyPageView: View {
    @State private var selectedTab = 0
    @State private var bookmarkedArticles: [Article] = []
    @State private var readArticles: [Article] = []
    
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
                ArticleListView(articles: bookmarkedArticles)
            } else {
                ArticleListView(articles: readArticles)
            }
        }
        // refresh articles when displaying myPage
        .onAppear {
            refreshArticles()
        }
        // refresh articles when switching tabs
        .onChange(of: selectedTab){
            refreshArticles()   
        }
    }
    private func refreshArticles() {
            // Reload the articles every time the view appears
            self.bookmarkedArticles = Array(articleStorage.fetchBookmarkedArticles())
            self.readArticles = Array(articleStorage.fetchReadArticles())
        }
}

struct ArticleListView: View {
    let articles: [Article]
    
    var body: some View {
        List(articles) { article in
            ArticleView(article: article)
        }
    }
}

#Preview {
    MyPageView()
}
