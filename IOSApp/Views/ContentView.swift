//
//  ContentView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 11.08.24.
//

import SwiftUI

// MARK: - ContentView Struct
// main entry point of the app's ui
struct ContentView: View {
    
    // MARK: - Properties
    @State private var selectedTab: Int = 0
    @StateObject var viewModel = NewsViewModelImpl(service: NewsServiceImpl(), filterService: FilterServiceImpl())
    
    // MARK: - Body
    var body: some View {
        // Switch between views based on the current state of the view model
        switch viewModel.state {
        case .loading:
            HomeView(viewModel: viewModel)
            
        case .success, .failed:
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
            
            // so tab bar is not invisible when first opening the app
            .onAppear {
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithOpaqueBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance // looks the same even when scrolled completely down
            }
            
            // handle tab changes
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
