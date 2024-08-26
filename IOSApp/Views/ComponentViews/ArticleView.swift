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
    
    // initialize
    init(article: Article, titleFontSize: CGFloat, iconSize: CGFloat, dateFontSize: CGFloat) {
        self.article = article
        self.titleFontSize = titleFontSize
        self.iconSize = iconSize
        self.dateFontSize = dateFontSize
    }
    
    // observe articleStorage to track changes of bookmarks
    @ObservedObject var articleStorage = ArticleStorageService.shared
    
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
                        articleStorage.toggleBookmark(for: article)
                    }) {
                        Image(systemName: articleStorage.bookmarkedArticles.contains(article) ? "bookmark.fill" : "bookmark")
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
    }
}
