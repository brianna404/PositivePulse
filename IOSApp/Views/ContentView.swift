//
//  ContentView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 11.08.24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: Int = 0
    @StateObject
    var viewModel = NewsViewModelImpl(service: NewsServiceImpl())
    
    var body: some View {
        if case .loading = viewModel.state {
            HomeView(viewModel: viewModel)
        }
        if case .success = viewModel.state {
            TabView(selection: $selectedTab) {
                HomeView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)
                
                SearchView() // Placeholder view
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Suche")
                    }
                    .tag(1)
                
                MyPageView() // Placeholder view
                    .tabItem {
                        Image(systemName: "bookmark")
                        Text("Mein Bereich")
                    }
                    .tag(2)
                
                SettingsView() // Placeholder view
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Einstellungen")
                    }
                    .tag(3)
            }
            .accentColor(ColorScheme.fontColor)
            // so tab bar is not invisible when first opening the app
            .onAppear {
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithOpaqueBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance // looks the same even when scrolled completely down
            }
            .onChange(of: selectedTab) {
                if selectedTab == 0 {
                    viewModel.loadNewArticles()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
