//
//  ErrorView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 29.07.24.
//

import SwiftUI

struct ErrorView: View {
    
    typealias ErrorViewActionHandler = () -> Void
    let error: Error
    let handler: ErrorViewActionHandler
    
    internal init(error: Error, handler: @escaping ErrorView.ErrorViewActionHandler) {
        self.error = error
        self.handler = handler
    }
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.icloud.fill")
                .foregroundStyle(Color.gray)
                .font(.system(size: 50, weight: .heavy))
            Text("Ooops")
                .foregroundStyle(Color.gray)
                .font(.system(size: 30))
            Text(error.localizedDescription)
                .foregroundStyle(Color.gray)
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
            Button(action: {
                handler()
            }, label: {
                Text("Retry")
           })
            .padding(.vertical, 12)
            .padding(.horizontal, 30)
            .background(Color.blue)
            .foregroundStyle(Color.white)
            .font(.system(size: 15, weight: .heavy))
            .cornerRadius(10)
            
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: APIError.decodingError) {}
    }
}
