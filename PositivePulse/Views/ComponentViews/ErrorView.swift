//
//  ErrorView.swift
//  PositivePulse
//
//  Created by Michelle Köhler on 29.07.24.
//

import SwiftUI

/// Displays an error message with a retry button.
struct ErrorView: View {
    
    /// Closure type for the retry action handler.
    typealias ErrorViewActionHandler = () -> Void
    /// The error to display.
    let error: Error
    /// Indicates if a search was committed.
    let searchCommitted: Bool
    /// Closure to handle the retry action.
    let handler: ErrorViewActionHandler
     
    /// Selected font size for text elements.
    @AppStorage("selectedFontSize") private var selectedFontSize = FontSizeState.medium
    
    /// Initializes the `ErrorView` with an error and a retry action handler.
    ///
    /// - Parameters:
    ///   - error: The error to display.
    ///   - searchCommitted: Indicates if a search was committed.
    ///   - handler: Closure to handle the retry action.
    init(error: Error, searchCommitted: Bool, handler: @escaping ErrorViewActionHandler) {
        self.error = error
        self.searchCommitted = searchCommitted
        self.handler = handler
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            if searchCommitted, let apiError = error as? APIError, apiError == .noArticles {
                // Custom message for no articles found.
                Text("Keine Ergebnisse gefunden.") 
                    .foregroundColor(.gray)
                    .padding()
            } else {
                // Error icon.
                Image(systemName: "exclamationmark.icloud.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 50, weight: .heavy))
                
                // Error title.
                Text("Ooops")
                    .foregroundColor(.gray)
                    .font(.system(size: selectedFontSize.fontSizeCGFloat["extraLargeTitle2"] ?? 28))
                
                // Error description.
                Text(error.localizedDescription)
                    .foregroundColor(.gray)
                    .font(.system(size: selectedFontSize.fontSizeCGFloat["body"] ?? 17))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 15)
                
                // Retry button.
                Button(action: {
                    handler()
                }) {
                    Text("Retry")
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 30)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .font(.system(size: selectedFontSize.fontSizeCGFloat["body"] ?? 17, weight: .heavy))
                .cornerRadius(10)
            }
            
            Spacer()
        }
    }
}
