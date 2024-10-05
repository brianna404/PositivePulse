//
//  ArticleView.swift
//  PositivePulse
//
//  Created by Michelle Köhler on 28.07.24.
//

import SwiftUI

/// Displays an article's image and information in a single view.
struct ArticleView: View {
    
    /// The article to display.
    let article: Article
    /// Font size for the article title.
    let titleFontSize: CGFloat
    /// Size for the icons.
    let iconSize: CGFloat
    /// Font size for the date and author.
    let dateFontSize: CGFloat
    
    /// Observed article storage to track bookmark changes.
    @ObservedObject var articleStorage = ArticleStorageService.shared
    
    /// Initializes the ArticleView with styling parameters.
    init(article: Article, titleFontSize: CGFloat, iconSize: CGFloat, dateFontSize: CGFloat) {
        self.article = article
        self.titleFontSize = titleFontSize
        self.iconSize = iconSize
        self.dateFontSize = dateFontSize
    }
    
    var body: some View {
        // Horizontal stack to display image and details side by side.
        HStack {
            // Article image.
            ArticleImageView(imgUrl: article.urlToImage)
                .frame(width: 100, height: 100)
            
            // Vertical stack for article details.
            VStack(alignment: .leading, spacing: 4) {
                // Display author if available.
                if let author = article.author, !author.isEmpty {
                    Text(author)
                        .foregroundColor(.gray)
                        .font(.system(size: dateFontSize))
                }
                
                // Title and bookmark button.
                HStack {
                    // Article title.
                    Text(article.title ?? "")
                        .font(.system(size: titleFontSize, weight: .semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    // Bookmark button.
                    Button(action: {
                        articleStorage.toggleBookmark(for: article)
                    }) {
                        Image(systemName: articleStorage.bookmarkedArticles.contains(article) ? "bookmark.fill" : "bookmark")
                    }
                    .frame(width: iconSize, height: iconSize)
                    .foregroundColor(.primary)
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Publication date.
                if let publishedAt = article.publishedAt {
                    Text(DateUtils.formatDate(dateString: publishedAt))
                        .foregroundColor(.gray)
                        .font(.system(size: dateFontSize))
                }
            }
        }
    }
}
