//
//  ErrorView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 29.07.24.
//

import SwiftUI

// MARK: - ErrorView Struct
// display error message and retry button

struct ErrorView: View {
    
    // Type alias for a closure that handles the retry action
    typealias ErrorViewActionHandler = () -> Void
    let error: Error // The error to display
    let searchCommitted: Bool // Flag to track if a search was committed
    let handler: ErrorViewActionHandler // Closure to handle retry action
     
    // Use AppStorage for setting fontSize of text elements
    @AppStorage("selectedFontSize") private var selectedFontSize = FontSizeState.medium
    
    // MARK: - ErrorViewInitializer
    // Initializer to set up the ErrorView with an error and a retry action handler
    internal init(error: Error, searchCommitted: Bool, handler: @escaping ErrorView.ErrorViewActionHandler) {
        self.error = error
        self.searchCommitted = searchCommitted
        self.handler = handler
    }
    
    var body: some View {
        
        VStack {
            Spacer() // for vertical centering
            
            // Conditionally render message only if a search was committed and the error is noArticles
            if searchCommitted, let apiError = error as? APIError, apiError == .noArticles {
                Text("Keine Ergebnisse gefunden.") // Custom message for noArticles error
                    .foregroundColor(.gray)
                    .padding()
            } else {
                // Icon error
                Image(systemName: "exclamationmark.icloud.fill")
                    .foregroundStyle(Color.gray)
                    .font(.system(size: 50, weight: .heavy))
                
                // Title text for error message
                Text("Ooops")
                    .foregroundStyle(Color.gray)
                    .font(.system(size: selectedFontSize.fontSizeCGFloat["extraLargTitle2"] ?? 28))
                
                // Display the localized error description
                Text(error.localizedDescription)
                    .foregroundStyle(Color.gray)
                    .font(.system(size: selectedFontSize.fontSizeCGFloat["body"] ?? 17))
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                
                // Retry button
                Button(action: {
                    handler() // Call the retry action handler
                }, label: {
                    Text("Retry")
                })
                .padding(.vertical, 12)
                .padding(.horizontal, 30)
                .background(Color.accentColor)
                .foregroundStyle(Color.white)
                .font(.system(size: selectedFontSize.fontSizeCGFloat["body"] ?? 17, weight: .heavy))
                .cornerRadius(10)
            }
            
            Spacer() // for vertical centering
        }
    }
}
