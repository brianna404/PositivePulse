//
//  HomeView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject
    var viewModel = NewsViewModelImpl(service: NewsServiceImpl())
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                        .padding()
                case .failed(error: let error):
                    ErrorView(error: error) {
                        viewModel.getArticles(category: viewModel.selectedCategoryStrg) }
                case .success(let content):
                    VStack {
                        CategoryFilterView(viewModel: viewModel)
                            .shadow(color: .gray, radius: 2, y: 4)
                            .padding(.top, 20)
                        List (viewModel.positiveArticles) { article in
                            if let urlString = article.url, let url = URL(string: urlString) {
                                NavigationLink(
                                    destination: ArticleWebView(url: url, article: article) // navigate to URL WebView
                                        .navigationTitle(article.title ?? "Article")
                                ) { ArticleView(article: article)
                                        .contentShape(Rectangle()) // Make the entire cell tappable
                                }
                            } else {
                                ArticleView(article: article)
                            }
                        }
                        .refreshable {
                            viewModel.refreshArticles()
                        }
                        .padding(EdgeInsets(top: 0, leading: -20, bottom: 0, trailing: -20))
                    }
                }
            }
            .onAppear {
                viewModel.getArticles(category: viewModel.selectedCategoryStrg)
            }
        }
    }
}
    
#Preview {
    HomeView()
}
