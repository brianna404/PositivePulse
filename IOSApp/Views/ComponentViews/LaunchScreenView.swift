//
//  LaunchScreenView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 22.08.24.
//

import Foundation
import SwiftUI

// MARK: - LaunchScreenView Struct
// Appears when articles are load and shows pulsing icon

struct LaunchScreenView: View {

    // Default scale for icon size
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        
        // VStack for icon image and app name
        VStack {
            
            Image("AppIconCodeUsage")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                // OnAppear triggers pulsing animation
                .onAppear {
                    withAnimation(
                        // Animation uses easeInOut curve to start and end slowly (in one second)
                        Animation.easeInOut(duration: 1.0)
                        // Keep repeating as long launchScreenView visible and scale reset to 1.0 before next animation
                            .repeatForever(autoreverses: true)
                    ) {
                        // Animation changes scale to 20% up
                        scale = 1.2
                    }
                }
                // Use set scale variable on image
                .scaleEffect(scale)
            
            Text("Positive Pulse")
                .fontWeight(.bold)
                .font(.system(size: 28))
        }
    }
}

#Preview {
    LaunchScreenView()
}
