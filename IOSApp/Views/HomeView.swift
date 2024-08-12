//
//  HomeView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject
    var viewModel = NewsViewModelImpl(service:  NewsServiceImpl())
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .padding()
            case .failed(error: let error):
                ErrorView(error: error, handler: viewModel.getArticles)
            case .success:
                List (viewModel.positiveArticles) { article in
                    if let urlString = article.url, let url = URL(string: urlString) {
                        Button(action: {
                            // Open URL in the browser
                            UIApplication.shared.open(url)
                        }) {
                            ArticleView(article: article)
                                .contentShape(Rectangle()) // Make the entire cell tappable
                        }
                    } else {
                        ArticleView(article: article)
                    }
                }
            }
        }
        .onAppear {
            if !viewModel.hasFetched {
                viewModel.getArticles()
            }
        }
    }
}
    
#Preview {
    HomeView()
}
