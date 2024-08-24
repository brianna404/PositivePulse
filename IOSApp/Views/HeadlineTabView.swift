//
//  HeadlineTabView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 20.08.24.
//

import SwiftUI

struct HeadlineTabView: View {
    @ObservedObject var articleStorage = ArticleStorage() // to track bookmarked status of articles
    
    let articles: [Article]
    
    @State private var currentHeadline = 0
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 400, height: 70)
                    .shadow(color: Color.white, radius: 8, y: 3)
                    .padding(.top, -10)
                HStack {
                    Image("AppIconCodeUsage")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                        .shadow(color: ColorScheme.fontColor, radius: 2)
                    Text("Your Feel-Good-Favorites")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
            
            TabView(selection: $currentHeadline) {
                ForEach(0..<3, id: \.self) { index in
                    if let article = articles[safe: index],
                       let urlString = article.url,
                       let url = URL(string: urlString) {
                        NavigationLink(
                            destination: ArticleWebView(url: url, article: article) // navigate to URL WebView
                                .navigationTitle(article.title ?? "Article")
                        ) {
                            ArticleView(article: article, titleFontSize: 22, iconSize: 50, dateFontSize: 14)
                                .contentShape(Rectangle())
                                .tag(index)
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(index == currentHeadline ? ColorScheme.fontColor : Color.white)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut(duration: 0.2), value: currentHeadline)
                }
            }
        }
            .frame(width: 350, height: 270)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    HomeView()
}
