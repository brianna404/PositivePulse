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
//            let url = URL(string: imgUrl) {
//            URLImage(url: url,
//                     options: URLImageOptions(
//                        identifier: article.id.uuidString,
//                        cachePolicy:
//                                .returnCacheDataElseLoad(cacheDelay: nil, downloadDelay: 0.25)
//            ),
//                     failure: { error,_ in
//                     PlaceholderImageView()
//                 },
//            content: { image in
//            image
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//            })
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title ?? "")
                    .foregroundStyle(Color.black)
                    .font(.system(size: 18, weight: .semibold))
                Text(article.author ?? "")
                    .foregroundStyle(Color.black)
                    .font(.footnote)
            }
        }
    }
}

//struct PlaceholderImageView: View {
//    var body: some View {
//        Image(systemName: "photo.fill")
//            .foregroundStyle(Color.white)
//            .background(Color.gray)
//            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
//    }
//}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: Article.dummyData)
    }
}
