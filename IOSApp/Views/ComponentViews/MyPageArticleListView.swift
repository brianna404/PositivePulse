//
//  MyPageArticleListView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 25.08.24.
//

import SwiftUI

// MARK: - MyPageArticleListView Struct
// displays a list of articles in the user's "My Page" section
struct MyPageArticleListView: View {
    
    // MARK: - Properties
    let articles: [Article]
    let emptyMessage: String
    
    // MARK: - Body
    var body: some View {
        // check if list is empty and if so display empty message
        if articles.isEmpty {
            Spacer()
            Text(emptyMessage)
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            Spacer()
        } else {
            // display read / bookmarked articles 
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
