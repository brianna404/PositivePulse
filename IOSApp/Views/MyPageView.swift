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
        NavigationStack {
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
                if selectedTab == 0 { // Bookmarked articles
                    if bookmarkedArticles.isEmpty {
                        Spacer() // display text in the middle
                        Text("Sobald du einen Artikel mit einem Lesezeichen versiehst, wird er hier angezeigt.")
                            .padding()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                        Spacer() // display text in the middle
                    } else {
                        ArticleListView(articles: bookmarkedArticles)
                    }
                } else { // read articles
                    if readArticles.isEmpty {
                        Spacer() // display text in the middle
                        Text("Sobald du einen Artikel gelesen hast, wird er hier angezeigt.")
                            .padding()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                        Spacer() // display text in the middle
                    } else {
                        ArticleListView(articles: readArticles)
                    }
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
    }
    
    private func refreshArticles() {
        // Fetch and sort bookmarked articles
        self.bookmarkedArticles = Array(articleStorage.fetchBookmarkedArticles())
            .sorted { ($0.lastBookmarked ?? Date.distantPast) > ($1.lastBookmarked ?? Date.distantPast) }
        
        // Fetch and sort read articles
        self.readArticles = Array(articleStorage.fetchReadArticles())
            .sorted { ($0.lastRead ?? Date.distantPast) > ($1.lastRead ?? Date.distantPast) }
    }
}

#Preview {
    MyPageView()
}
