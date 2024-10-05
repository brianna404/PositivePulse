//
//  HeadlineTabView.swift
//  PositivePulse
//
//  Created by Michelle Köhler on 20.08.24.
//

import SwiftUI

/// Shows the first three articles in a slider.
struct HeadlineTabView: View {
    
    /// Array containing the first three articles.
    let articles: [Article]
    /// Selected font size for text elements.
    @AppStorage("selectedFontSize") private var selectedFontSize = FontSizeState.medium
    /// Observed view model instance.
    @ObservedObject var viewModel = NewsViewModelImpl(service: NewsServiceImpl(), filterService: FilterServiceImpl())
    /// Current headline index.
    @State private var currentHeadline = 0
    
    var body: some View {
        VStack {
            // Header with app icon and title.
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemBackground))
                    .frame(width: 400, height: 70)
                    .shadow(color: Color(UIColor.systemBackground), radius: 8, y: 3)
                    .padding(.top, -10)
                
                HStack {
                    Image("AppIconCodeUsage")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(10)
                        .shadow(color: Color.accentColor, radius: 2)
                    
                    Text("Your Feel-Good-Favorites")
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
            
            // Tab view for sliding articles horizontally.
            TabView(selection: $currentHeadline) {
                // Iterate through the first three articles.
                ForEach(0..<3, id: \.self) { index in
                    // Safely access article by index.
                    if let article = articles[safe: index],
                       let urlString = article.url,
                       let url = URL(string: urlString) {
                        
                        // Navigation link to the article's web view.
                        NavigationLink(
                            destination: ArticleWebView(url: url, article: article)
                                .navigationTitle(article.title ?? "Article")
                        ) {
                            ArticleView(
                                article: article,
                                titleFontSize: selectedFontSize.fontSizeCGFloat["title2"] ?? 22,
                                iconSize: 50,
                                dateFontSize: selectedFontSize.fontSizeCGFloat["subheadline"] ?? 15
                            )
                            .contentShape(Rectangle())
                            .tag(index)
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Indicator dots.
            HStack {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(index == currentHeadline ? Color.accentColor : Color.white)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut(duration: 0.2), value: currentHeadline)
                }
            }
        }
        .frame(width: 350, height: 270)
        .padding(.horizontal, 10)
    }
}

/// Extension to safely access collection elements by index.
extension Collection {
    /// Safely accesses the element at the specified index.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    HomeView()
}
