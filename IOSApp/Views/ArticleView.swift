//
//  ArticleView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 28.07.24.
//

import SwiftUI
//import URLImage

struct ArticleView: View {
    
    let article: Article // The article data to be displayed
    // maybe insert picture with URLImage?
    
    // view's layout and appearance
    var body: some View {
        HStack {
        // Uncomment and configure the following block if URLImage is used for image loading
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
                // vertical stack to display article details
                VStack(alignment: .leading, spacing: 4) {
        
                    // Display the author of the article, if available
                    Text(article.author ?? "")
                        .foregroundStyle(Color.black)
                        .font(.footnote)
                    
                    // horizontal stack to display title and a bookmark icon
                    HStack {
                        // Display the title of the article
                        Text(article.title ?? "")
                            .foregroundStyle(Color.black)
                            .font(.system(size: 18, weight: .semibold))
                        Spacer() // Pushes the bookmark icon to the end
                        Image(systemName: "bookmark") // Bookmark icon
                    }
                    
                    // Display the description of the article, if available
                    Text(article.description ?? "")
                        .foregroundStyle(Color.black)
                    // Display the formatted publication date
                    Text(formatDate(dateString: article.publishedAt ?? ""))
                        .foregroundStyle(Color.gray)
                        .font(.system(size: 11))
                }
            }
        }
    }

// placeholder view for the article image if image loading fails
struct PlaceholderImageView: View {
    var body: some View {
        Image(systemName: "photo.fill") // Placeholder image
            .foregroundStyle(Color.white)
            .background(Color.gray) // Background color for placeholder
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/) // size
    }
}

//struct ArticleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArticleView(article: Article.dummyData)
//    }
//}

// Function to format date strings
func formatDate(dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Original Format
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "dd.MM.yyy HH:mm" // Desired Format
    outputFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date) // Return formatted date string
    } else {
        return dateString // Fallback if parsing fails
    }
}
