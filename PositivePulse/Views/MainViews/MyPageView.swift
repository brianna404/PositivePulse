//
//  MyPageView.swift
//  PositivePulse
//
//  Created by Brianna Kruschke on 11.08.24.
//

import SwiftUI

/// Displays the user's bookmarked and read articles in tabs.
struct MyPageView: View {
    @State private var selectedTab = 0
    @State private var bookmarkedArticles: [Article] = []
    @State private var readArticles: [Article] = []
    
    /// Observed article storage service.
    @ObservedObject var articleStorage = ArticleStorageService.shared
    
    init() {
        // Set the background color of the segmented control to accent color.
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.accentColor)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Tab selection.
                Picker(selection: $selectedTab, label: Text("")) {
                    Text("Gemerkt").tag(0)
                    Text("Gelesen").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 16)
                .padding(.horizontal, 16)
                
                // Tab views.
                if selectedTab == 0 {
                    MyPageArticleListView(
                        articles: bookmarkedArticles,
                        emptyMessage: "Sobald du einen Artikel mit einem Lesezeichen versiehst, wird er hier angezeigt."
                    )
                } else {
                    MyPageArticleListView(
                        articles: readArticles,
                        emptyMessage: "Sobald du einen Artikel gelesen hast, wird er hier angezeigt."
                    )
                }
            }
            // Refresh articles when the view appears.
            .onAppear {
                refreshArticles()
            }
            // Refresh articles when switching tabs.
            .onChange(of: selectedTab) { _ in
                refreshArticles()
            }
        }
        .background(Color.background)
    }
    
    /// Fetches and sorts bookmarked and read articles.
    private func refreshArticles() {
        // Fetch and sort bookmarked articles.
        self.bookmarkedArticles = Array(articleStorage.fetchBookmarkedArticles())
            .sorted { ($0.lastBookmarked ?? Date.distantPast) > ($1.lastBookmarked ?? Date.distantPast) }
        
        // Fetch and sort read articles.
        self.readArticles = Array(articleStorage.fetchReadArticles())
            .sorted { ($0.lastRead ?? Date.distantPast) > ($1.lastRead ?? Date.distantPast) }
    }
}

#Preview {
    MyPageView()
}
