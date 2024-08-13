//
//  ArticleView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 28.07.24.
//

import SwiftUI
import URLImage

struct ArticleView: View {
    
    let article: Article
    // track bookmarked status
    @State private var isBookmarked: Bool
    
    // place to store bookmarked articles
    private let articleStorage = ArticleStorage()
    
    // initialize
    init(article: Article) {
           self.article = article
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
                        .foregroundStyle(Color.black)
                        .font(.system(size: 18, weight: .semibold))
                    Spacer()
                    Button(action: {
                        // Call the toggleBookmark function from ArticleStorage
                        let updatedArticle = articleStorage.toggleBookmark(for: article)
                        isBookmarked = updatedArticle.isBookmarked ?? false
                    }) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    }
                    .buttonStyle(PlainButtonStyle()) // otherwise Bookmark icon not clickable
                }
                Text(DateUtils.formatDate(dateString: article.publishedAt ?? ""))
                    .foregroundStyle(Color.gray)
                    .font(.system(size: 11))
            }
        }
        .onTapGesture {
            // Open URL when the article is clicked on
            if let urlString = article.url, let url = URL(string: urlString) {
                UIApplication.shared.open(url)
                // Mark article as read
                let updatedArticle = article
                updatedArticle.isRead = true
                articleStorage.addOrUpdateArticle(updatedArticle)
            }
        }
    }
}
    
// image loading logic -> separated to prevent image from reloading when bookmark icon is clicked
struct ArticleImageView: View {
    let imgUrl: String?
    
    var body: some View {
        if let imgUrl = imgUrl, let url = URL(string: imgUrl) {
            URLImage(url) {
                // view displayed before download starts
                EmptyView()
            } inProgress: { progress in
                // Display progress
                Text("Loading...")
            } failure: { error, retry in
                // if error accured
                PlaceholderImageView()
            } content: { image in
                // Downloaded image
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
            }
        }
    }
}

// placeholder view for the article image if image loading fails
struct PlaceholderImageView: View {
    var body: some View {
        Image(systemName: "photo.fill") // Placeholder image
            .foregroundStyle(Color.white)
            .background(Color.gray) // Background color for placeholder
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/) // size
    }
}

