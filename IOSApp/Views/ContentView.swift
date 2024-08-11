//
//  ContentView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 11.08.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            SearchView() // Placeholder view
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Suche")
                }
            
            MyPageView() // Placeholder view
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("Mein Bereich")
                }
            
            SettingsView() // Placeholder view
                .tabItem {
                    Image(systemName: "gear")
                    Text("Einstellungen")
                }
        }
    }
}

#Preview {
    ContentView()
}
