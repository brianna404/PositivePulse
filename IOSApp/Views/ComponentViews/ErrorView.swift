//
//  ErrorView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 29.07.24.
//

import SwiftUI

// display error message and retry button
struct ErrorView: View {
    
    // Type alias for a closure that handles the retry action
    typealias ErrorViewActionHandler = () -> Void
    let error: Error // The error to display
    let handler: ErrorViewActionHandler // Closure to handle retry action
     
    // Initializer to set up the ErrorView with an error and a retry action handler
    internal init(error: Error, handler: @escaping ErrorView.ErrorViewActionHandler) {
        self.error = error
        self.handler = handler
    }
    
    // layout and appearance
    var body: some View {
        VStack {
            // Icon error
            Image(systemName: "exclamationmark.icloud.fill")
                .foregroundStyle(Color.gray)
                .font(.system(size: 50, weight: .heavy))
            // Title text for error message
            Text("Ooops")
                .foregroundStyle(Color.gray)
                .font(.system(size: 30))
            // Display the localized error description
            Text(error.localizedDescription)
                .foregroundStyle(Color.gray)
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
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
            .font(.system(size: 15, weight: .heavy))
            .cornerRadius(10)
            
        }
    }
}

// Preview provider to show a preview of the ErrorView
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an ErrorView instance with a sample error and an empty retry handler
        ErrorView(error: APIError.unkown) {}
    }
}
