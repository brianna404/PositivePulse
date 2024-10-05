//
//  MyPageArticleListView.swift
//  PositivePulse
//
//  Created by Brianna Kruschke on 25.08.24.
//

import SwiftUI

/// Displays a list of articles in the user's "My Page" section.
struct MyPageArticleListView: View {
    
    /// The articles to display.
    let articles: [Article]
    /// Message to display when the list is empty.
    let emptyMessage: String
    
    var body: some View {
        if articles.isEmpty {
            Spacer()
            Text(emptyMessage)
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            Spacer()
        } else {
            // Display read or bookmarked articles.
            List {
                ArticleListView(articles: articles)
            }
            .listStyle(PlainListStyle())
            .padding(.top, 10)
            .padding(.horizontal, 20)
            .padding(EdgeInsets(top: 0, leading: -15, bottom: 0, trailing: -15))
        }
    }
}
