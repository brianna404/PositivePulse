//
//  HomeView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import SwiftUI

// MARK: - HomeView Struct
// First page shown to the user when opening the app

struct HomeView: View {
    
    // Observe object NewsViewModelImp provided from contentView
    @ObservedObject
    var viewModel = NewsViewModelImpl(service: NewsServiceImpl(), filterService: FilterServiceImpl())

    var body: some View {
        
        // Container for navigation to ArticleWebView
        NavigationStack {
            
            // Group views in logical parts as group
            Group {
                
                switch viewModel.state {
                // Show LaunchScreenView while loading
                case .loading:
                    LaunchScreenView()
                    
                // Show ErrorView if error occured
                case .failed(error: let error):
                    ErrorView(error: error) {
                        viewModel.getArticles(category: viewModel.selectedCategory, keyword: nil, country: viewModel.selectedCountry) }
                    
                // Show TabView headlines and list of articles when request was successful
                case .success(let content):
                    // VStack for ordering CategoryFIlterView, HeadlineTabVIew and ArticleListView vertically
                    VStack {
                        
                        CategoryFilterView(viewModel: viewModel)
                            .shadow(color: Color.gray, radius: 2, y: 4)
                        
                        // HeadlineTabView and ArticleListView in sections in list for scrolling
                        List {
                            Section {
                                ZStack {
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                    // System background color for switching between light and darkmode
                                        .fill(LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemBackground), Color.background]), startPoint: .top, endPoint: .bottom))
                                        .opacity(0.7)
                                    
                                    // Take only first three articles from article array
                                    HeadlineTabView(articles: selectFirstThreeArticles(from: viewModel.positiveArticles))
                                        .padding(EdgeInsets(top: 5, leading: 7, bottom: 10, trailing: 7))
                                }
                            }
                            .padding(EdgeInsets(top: -10, leading: -10, bottom: -10, trailing: -10))
                            
                            Section {
                                // Take all articles except first three ones
                                ArticleListView(articles: dropFirstThree(from: viewModel.positiveArticles))
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: -15, bottom: 0, trailing: -15))
                        // On refresh trigger load articles new without entering loading state
                        .refreshable {
                            viewModel.loadNewArticles()
                        }
                    }
                }
            }
            // On appear get articles initially
            .onAppear {
                viewModel.getArticles(category: viewModel.selectedCategory, keyword: nil, country: viewModel.selectedCountry)
            }
        }
    }
}

// Returns first three articles of article array
func selectFirstThreeArticles(from articles: [Article]) -> [Article] {
    return Array(articles.prefix(3))
}

// Returns all articles ecxept first three ones from article array
func dropFirstThree(from articles: [Article]) -> [Article]  {
    return Array(articles.dropFirst(3))
}
    
#Preview {
    HomeView()
}
