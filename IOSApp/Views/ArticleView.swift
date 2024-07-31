//
//  ArticleView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 28.07.24.
//

import SwiftUI
//import URLImage

struct ArticleView: View {
    
    let article: Article
    //maybe insert picture with URLImage?
    
    var body: some View {
        HStack {
//            if let imgUrl = article.urlToImage,
//               let url = URL(string: imgUrl) {
//                
//                URLImage(url: url,
//                         identifier: article.id.uuidString
////                         options: URLImageOptions(
////                            fetchPolicy: .returnCacheElseLoad(cacheDelay: nil, downloadDelay: 0.25))
//                ),
//            failure: { error,_ in
//                PlaceholderImageView()
//            }, content: { image in
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//            }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.author ?? "")
                        .foregroundStyle(Color.black)
                        .font(.footnote)
                    HStack {
                        Text(article.title ?? "")
                            .foregroundStyle(Color.black)
                            .font(.system(size: 18, weight: .semibold))
                        Spacer()
                        Image(systemName: "bookmark")
                    }
                    Text(article.description ?? "")
                        .foregroundStyle(Color.black)
                    Text(formatDate(dateString: article.publishedAt ?? ""))
                        .foregroundStyle(Color.gray)
                        .font(.system(size: 11))
                }
            }
        }
    }

struct PlaceholderImageView: View {
    var body: some View {
        Image(systemName: "photo.fill")
            .foregroundStyle(Color.white)
            .background(Color.gray)
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: Article.dummyData)
    }
}

func formatDate(dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Original Format
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "dd.MM.yyy HH:mm" // Desired Format
    outputFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    } else {
                return dateString // Fallback if parsing fails
            }
}
