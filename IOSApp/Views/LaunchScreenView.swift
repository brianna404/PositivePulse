//
//  LaunchScreenView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 22.08.24.
//

import Foundation
import SwiftUI

struct LaunchScreenView: View {

    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            Image("AppIconCodeUsage")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .onAppear {
                    withAnimation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true)
                    ) {
                        scale = 1.2
                    }
                }
                .scaleEffect(scale)
            
            Text("Positive Pulse")
                .fontWeight(.bold)
                .font(.title)
        }
    }
}

#Preview {
    LaunchScreenView()
}
