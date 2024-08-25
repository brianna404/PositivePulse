//
//  ArticleImageView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 25.08.24.
//

import SwiftUI
import URLImage

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
    }
}
