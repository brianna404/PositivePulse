//
//  HeadlineArticleView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 20.08.24.
//

import SwiftUI
import URLImage

struct HeadlineArticleView: View {
    
    let article: Article
    
    // track bookmarked status
    @State private var isBookmarked: Bool
    
    // place to store bookmarked articles
    @ObservedObject private var articleStorage = ArticleStorage()
    
    // initialize
    init(article: Article) {
        self.article = article
        self._isBookmarked = State(initialValue: article.isBookmarked ?? false)
    }
    
    var body: some View {
        
        // vertical stack to display article details
        VStack(alignment: .leading, spacing: 4) {
            Text(article.author ?? "")
                .foregroundStyle(Color.gray)
                .font(.footnote)
            HStack {
                Text(article.title ?? "")
                    .foregroundStyle(Color.black)
                    .font(.system(size: 22, weight: .semibold))
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                    .multilineTextAlignment(.leading)
                Spacer()
                Button(action: {
                    // Call the toggleBookmark function from ArticleStorage
                    let updatedArticle = articleStorage.toggleBookmark(for: article)
                    isBookmarked = updatedArticle.isBookmarked ?? false
                }) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                }
                .frame(width: 50, height: 50)
                .foregroundStyle(Color.black)
                .buttonStyle(PlainButtonStyle()) // otherwise Bookmark icon not clickable
            }
            Text(article.description ?? "")
                .foregroundStyle(Color.black)
            Text(DateUtils.formatDate(dateString: article.publishedAt ?? ""))
                .foregroundStyle(Color.gray)
                .font(.system(size: 14))
        }
        .onAppear {
            // Ensure that the bookmark status is up-to-date when the view appears
            isBookmarked = articleStorage.bookmarkedArticles.contains(article)
        }
    }
    
}

