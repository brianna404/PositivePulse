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
    @ObservedObject var articleStorage = ArticleStorage() // to track bookmarked status of articles

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                        LaunchScreenView()
                case .failed(error: let error):
                    ErrorView(error: error) {
                        viewModel.getArticles(category: viewModel.selectedCategoryStrg) }
                case .success(let content):
                    VStack {
                        CategoryFilterView(viewModel: viewModel)
                            .shadow(color: .gray, radius: 2, y: 4)
                        List {
                            Section {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(LinearGradient(gradient: Gradient(colors: [.white, ColorScheme.backgroundColor]), startPoint: .top, endPoint: .bottom))
                                        .opacity(0.7)
                                    HeadlineTabView(articles: selectFirstThreeArticles(from: viewModel.positiveArticles))
                                        .padding(EdgeInsets(top: 5, leading: 7, bottom: 10, trailing: 7))
                                }
                            }
                            .padding(EdgeInsets(top: -10, leading: -10, bottom: -10, trailing: -10))
                            Section {
                                ArticleListView(articles: dropFirstThree(from: viewModel.positiveArticles))
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: -15, bottom: 0, trailing: -15))
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

func selectFirstThreeArticles(from articles: [Article]) -> [Article] {
    return Array(articles.prefix(3))
}
func dropFirstThree(from articles: [Article]) -> [Article]  {
    return Array(articles.dropFirst(3))
}
    
#Preview {
    HomeView()
}
