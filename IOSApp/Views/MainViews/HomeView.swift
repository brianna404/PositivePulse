//
//  HomeView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import SwiftUI

/// The first page shown to the user when opening the app.
struct HomeView: View {
    
    /// Observed view model for fetching and managing articles.
    @ObservedObject var viewModel = NewsViewModelImpl(service: NewsServiceImpl(), filterService: FilterServiceImpl())
    /// Tracks if the app is launched for the first time.
    @State private var isFirstLaunch = true

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    // Show launch screen while loading.
                    LaunchScreenView()
                    
                case .failed(error: let error):
                    // Show error view if an error occurred.
                    ErrorView(error: error, searchCommitted: false) {
                        viewModel.getArticles(
                            category: viewModel.selectedCategory,
                            keyword: nil,
                            country: viewModel.selectedCountry
                        )
                    }
                    
                case .success:
                    // Display content when the request is successful.
                    VStack {
                        // Category filter at the top.
                        CategoryFilterView(viewModel: viewModel)
                            .shadow(color: .gray, radius: 2, y: 4)
                        
                        // Headline and article list.
                        List {
                            // Headline section with the first three articles.
                            Section {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color(UIColor.systemBackground), Color.background]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .opacity(0.7)
                                    
                                    HeadlineTabView(articles: selectFirstThreeArticles(from: viewModel.positiveArticles))
                                        .padding(EdgeInsets(top: 5, leading: 7, bottom: 10, trailing: 7))
                                }
                            }
                            .padding(EdgeInsets(top: -10, leading: -10, bottom: -10, trailing: -10))
                            
                            // Article list section with the remaining articles.
                            Section {
                                ArticleListView(articles: dropFirstThree(from: viewModel.positiveArticles))
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: -15, bottom: 0, trailing: -15))
                        // Refresh articles on pull-down gesture.
                        .refreshable {
                            viewModel.loadNewArticles()
                        }
                    }
                }
            }
            // Initial article fetch on view appear.
            .onAppear {
                if isFirstLaunch {
                    viewModel.selectedCategory = .general
                    isFirstLaunch = false
                }
                viewModel.getArticles(
                    category: viewModel.selectedCategory,
                    keyword: nil,
                    country: viewModel.selectedCountry
                )
            }
        }
    }
}

/// Returns the first three articles from the array.
func selectFirstThreeArticles(from articles: [Article]) -> [Article] {
    Array(articles.prefix(3))
}

/// Returns all articles except the first three from the array.
func dropFirstThree(from articles: [Article]) -> [Article]  {
    Array(articles.dropFirst(3))
}

#Preview {
    HomeView()
}
