//
//  MyPageArticleListView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 25.08.24.
//

import SwiftUI

struct MyPageArticleListView: View {
    let articles: [Article]
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
