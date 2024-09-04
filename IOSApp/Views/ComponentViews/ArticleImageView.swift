//
//  ArticleImageView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 25.08.24.
//

import SwiftUI
import URLImage

// MARK: - ArticleImageView Struct
// Image loading logic
struct ArticleImageView: View {
    
    // MARK: - Attributes
    let imgUrl: String?
    
    var body: some View {
        if let imgUrl = imgUrl, let url = URL(string: imgUrl) {
            URLImage(url) {
                // View displayed before download starts
                EmptyView()
            } inProgress: { progress in
                // Display progress
                Text("Loading...")
            } failure: { error, retry in
                // If error accured
                PlaceholderImageView()
            } content: { image in
                // Downloaded image
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

// MARK: - PlaceholderImageView Struct
// Placeholder view for the article image if image loading fails
struct PlaceholderImageView: View {
    var body: some View {
        // Placeholder image
        Image(systemName: "photo.fill")
            .foregroundStyle(Color.white)
            // Background color for placeholder
            .background(Color.gray)
    }
}
