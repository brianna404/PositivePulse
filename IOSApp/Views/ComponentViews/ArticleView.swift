//
//  ArticleView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 28.07.24.
//

import SwiftUI

// MARK: - ArticleView Struct
// Image and article information in single article view
struct ArticleView: View {
    
    // MARK: - Attributes
    let article: Article
    // Styling elements provided as parameters for styling article as list or headline articles in tabview
    let titleFontSize: CGFloat
    let iconSize: CGFloat
    let dateFontSize: CGFloat
    
    // Initializer
    init(article: Article, titleFontSize: CGFloat, iconSize: CGFloat, dateFontSize: CGFloat) {
        self.article = article
        self.titleFontSize = titleFontSize
        self.iconSize = iconSize
        self.dateFontSize = dateFontSize
    }
    
    // Observe articleStorage to track changes of bookmarks
    @ObservedObject var articleStorage = ArticleStorageService.shared
    
    var body: some View {
        // Horizontal stack to display image and details on horizontal line next to eachother
        HStack {
            // Load image and provide URL of image of given article
            ArticleImageView(imgUrl: article.urlToImage)
            
            // Vertical stack to display article details
            VStack(alignment: .leading, spacing: 4) {
                // If author not empty show author
                Text(article.author ?? "")
                    .foregroundStyle(Color.gray)
                    .font(.footnote)
                
                // Show bookmarkButton on horizontal line next to title and date
                HStack {
                    // If title not empty show title
                    Text(article.title ?? "")
                        // Show title in provided titleFontSize fontsize
                        .font(.system(size: titleFontSize, weight: .semibold))
                        // Use default color for switching between darkmode and lightmode
                        .foregroundStyle(Color.primary)
                        // Align long titles with mutliple lines in leading position
                        .multilineTextAlignment(.leading)
                    
                    // Creates space between title and bookmark button
                    Spacer()
                    
                    // Bookmark button is default untoggled
                    Button(action: {
                        // Toggle bookmark status
                        articleStorage.toggleBookmark(for: article)
                    }) {
                        // If article is in articleStorage.bookmarkedArticles safed show filled icon, else unfilled icon
                        Image(systemName: articleStorage.bookmarkedArticles.contains(article) ? "bookmark.fill" : "bookmark")
                    }
                    // Show icon in provided iconSize imagesize
                    .frame(width: iconSize, height: iconSize)
                    // Use default color for switching between darkmode and lightmode
                    .foregroundStyle(Color.primary)
                    // Makes bookmark icon clickable
                    .buttonStyle(PlainButtonStyle())
                }
                
                // If publish date provided show date
                // DateUtils formats date from JSON (provided by api) into user friendly readable date format
                Text(DateUtils.formatDate(dateString: article.publishedAt ?? ""))
                    .foregroundStyle(Color.gray)
                    // Show date in provided dateFontSize fontsize
                    .font(.system(size: dateFontSize))
            }
        }
    }
}
