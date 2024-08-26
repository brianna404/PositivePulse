//
//  ArticleView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 28.07.24.
//

import SwiftUI

struct ArticleView: View {
    
    let article: Article
    let titleFontSize: CGFloat
    let iconSize: CGFloat
    let dateFontSize: CGFloat
    
    // track bookmarked status
    @State private var isBookmarked: Bool
    
    // track bookmarked articles
    @ObservedObject private var articleStorage = ArticleStorageService()
    
    // initialize
    init(article: Article, titleFontSize: CGFloat, iconSize: CGFloat, dateFontSize: CGFloat) {
        self.article = article
        self.titleFontSize = titleFontSize
        self.iconSize = iconSize
        self.dateFontSize = dateFontSize
        self._isBookmarked = State(initialValue: article.isBookmarked ?? false)
    }
    
    var body: some View {
        // vertical stack to display article details
        HStack {
            // load image
            ArticleImageView(imgUrl: article.urlToImage)
            
            // display information
            VStack(alignment: .leading, spacing: 4) {
                Text(article.author ?? "")
                    .foregroundStyle(Color.gray)
                    .font(.footnote)
                HStack {
                    Text(article.title ?? "")
                        .font(.system(size: titleFontSize, weight: .semibold))
                        .foregroundStyle(Color.primary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    // Bookmark button
                    Button(action: {
                        // toggle bookmark status
                        let updatedArticle = articleStorage.toggleBookmark(for: article)
                        isBookmarked = updatedArticle.isBookmarked ?? false
                    }) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    }
                    .frame(width: iconSize, height: iconSize)
                    .foregroundStyle(Color.primary)
                    .buttonStyle(PlainButtonStyle()) // otherwise Bookmark icon not clickable
                }
                Text(DateUtils.formatDate(dateString: article.publishedAt ?? ""))
                    .foregroundStyle(Color.gray)
                    .font(.system(size: dateFontSize))
            }
        }
        .onAppear {
            // Ensure that the bookmark status is up-to-date when the view appears
            isBookmarked = articleStorage.bookmarkedArticles.contains(article)
        }
    }
}
