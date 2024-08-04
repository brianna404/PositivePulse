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
                Text("Loading...")
            case.failed(error: let error):
                ErrorView(error: error, handler: viewModel.getArticles)
            case .success(let articles):
                NavigationView {
                    List(viewModel.positiveArticles) { item in // viewModel.positiveArticles ändern zu articles, um ungefilterte anzuschauen?
                        ArticleView(article: item)
                    }
                }
            }
        }
        .onAppear(perform: viewModel.getArticles)
    }
}

#Preview {
    HomeView()
}
