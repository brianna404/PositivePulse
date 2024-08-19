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
                        ArticleListView(articles: viewModel.positiveArticles)
                        .refreshable {
                                viewModel.loadNewArticles()
                            }
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
