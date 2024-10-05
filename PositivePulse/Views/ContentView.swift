//
//  ContentView.swift
//  PositivePulse
//
//  Created by Brianna Kruschke on 11.08.24.
//

import SwiftUI

/// Main entry point of the app's UI.
struct ContentView: View {
    
    /// Currently selected tab index.
    @State private var selectedTab: Int = 0
    /// Observed view model for managing articles.
    @StateObject var viewModel = NewsViewModelImpl(service: NewsServiceImpl(), filterService: FilterServiceImpl())
    
    var body: some View {
        // Switch between views based on the current state of the view model.
        switch viewModel.state {
        case .loading:
            // Show home view during loading.
            HomeView(viewModel: viewModel)
            
        case .success, .failed:
            // Main tab view with multiple tabs.
            TabView(selection: $selectedTab) {
                // Home Tab
                HomeView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)
                
                // Search Tab
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Suche")
                    }
                    .tag(1)
                
                // My Page Tab
                MyPageView()
                    .tabItem {
                        Image(systemName: "bookmark")
                        Text("Mein Bereich")
                    }
                    .tag(2)
                
                // Settings Tab
                SettingsView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Einstellungen")
                    }
                    .tag(3)
            }
            .accentColor(Color.accentColor)
            
            // Ensure tab bar is visible when first opening the app.
            .onAppear {
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithOpaqueBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
            
            // Handle tab changes.
            .onChange(of: selectedTab) { _ in
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
