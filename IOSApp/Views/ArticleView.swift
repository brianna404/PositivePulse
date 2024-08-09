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
    
    var body: some View {
        // vertical stack to display article details
        HStack {
            // URLImage used for image loading
            if let imgUrl = article.urlToImage,
               let url = URL(string: imgUrl) {
                URLImage(url) {
                    // This view is displayed before download starts
                    EmptyView()
                } inProgress: { progress in
                    // Display progress
                    Text("Loading...")
                } failure: { error, retry in
                    //if error accured
                    PlaceholderImageView()
                } content: { image in
                    // Downloaded image
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.author ?? "")
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                    HStack {
                        Text(article.title ?? "")
                            .foregroundStyle(Color.black)
                            .font(.system(size: 18, weight: .semibold))
                        Spacer()
                        Image(systemName: "bookmark")
                    }
                    Text(DateUtils.formatDate(dateString: article.publishedAt ?? ""))
                        .foregroundStyle(Color.gray)
                        .font(.system(size: 11))
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
}
