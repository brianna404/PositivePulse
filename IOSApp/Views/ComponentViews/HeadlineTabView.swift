//
//  HeadlineTabView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 20.08.24.
//

import SwiftUI

// MARK: - HeadlineTabView Struct
// show first three articles in a slider

struct HeadlineTabView: View {
    
    // Array to hold first three fetched articles
    let articles: [Article]
    
    // Default value for headline is article with index 0
    @State private var currentHeadline = 0
    
    var body: some View {
        
        // Vertical stack to display positive pulse title and articles
        VStack {
            
            // ZStack for bringing rectangle in the background
            ZStack {
                
                RoundedRectangle(cornerRadius: 10)
                    // System background color for switching between light and darkmode
                    .fill(Color(UIColor.systemBackground))
                    .frame(width: 400, height: 70)
                    // System background color for switching between light and darkmode
                    .shadow(color: Color(UIColor.systemBackground), radius: 8, y: 3)
                    .padding(.top, -10)
                
                // HStack for showing icon and title positive pulse in horizontal line
                HStack {
                    
                    Image("AppIconCodeUsage")
                        .resizable()
                        .frame(width: 30, height: 30)
                        // System background color for switching between light and darkmode
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(10)
                        .shadow(color: Color.accentColor, radius: 2)
                    
                    Text("Your Feel-Good-Favorites")
                        .fontWeight(.bold)
                        // System primary color for switching between light and darkmode
                        .foregroundStyle(Color.primary)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
            
            // Tabview for sliding articles horizontal
            TabView(selection: $currentHeadline) {
                
                // Iterate thouugh first three elements
                ForEach(0..<3, id: \.self) { index in
                    
                    // Safes access to article with defined index even if index not available in array
                    if let article = articles[safe: index],
                       let urlString = article.url,
                       let url = URL(string: urlString) {
                        
                        // Creating navigational link between HeadlineTabView and ArticleWebView
                        NavigationLink(
                            // Navigate to URL WebView
                            destination: ArticleWebView(url: url, article: article)
                            // Show title of article as title on ArticleWebView
                                .navigationTitle(article.title ?? "Article")
                        ) {
                            
                            // ArticleView as clickable object for navigation
                            ArticleView(article: article, titleFontSize: 22, iconSize: 50, dateFontSize: 14)
                                .contentShape(Rectangle())
                            // Tags every ArticleView with index of article
                                .tag(index)
                        }
                    }
                }
            }
            // Not showing default displaying of index of tabView slider
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // HStack for indicating points on horizontal line
            HStack {
                
                // Iterating through index 0 to 2
                ForEach(0..<3) { index in
                    
                    // Displays index points at bottom of TabView slider
                    Circle()
                        // Change color when sliding
                        .fill(index == currentHeadline ? Color.accentColor : Color.white)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut(duration: 0.2), value: currentHeadline)
                }
            }
        }
            .frame(width: 350, height: 270)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
}

// MARK: - Conformance to HeadlineTabView
// Extends standard collection types for safe access in array

extension Collection {
    // Subscript accesses elements from collection
    subscript(safe index: Index) -> Element? {
        // If index is insight indices (collection) return element otherwise nil
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    HomeView()
}
