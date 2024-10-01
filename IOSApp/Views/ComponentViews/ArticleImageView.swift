//
//  ArticleImageView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 25.08.24.
//

import SwiftUI
import URLImage

/// Displays an image for an article, handling loading states and errors.
struct ArticleImageView: View {
    
    /// The URL string of the article's image.
    let imgUrl: String?
    
    var body: some View {
        if let imgUrl = imgUrl, let url = URL(string: imgUrl) {
            URLImage(url) {
                // View before download starts
                EmptyView()
            } inProgress: { progress in
                // Display loading progress
                Text("Lädt...")
            } failure: { error, retry in
                // Placeholder on error
                PlaceholderImageView()
            } content: { image in
                // Display downloaded image
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        } else {
            // Placeholder if URL is invalid or nil
            PlaceholderImageView()
        }
    }
}

/// Placeholder view displayed when the image fails to load.
struct PlaceholderImageView: View {
    
    var body: some View {
        Image(systemName: "photo.fill")
            .foregroundStyle(Color.white)
            .background(Color.gray)
    }
}
