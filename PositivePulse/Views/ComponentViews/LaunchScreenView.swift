//
//  LaunchScreenView.swift
//  PositivePulse
//
//  Created by Michelle Köhler on 22.08.24.
//

import SwiftUI

/// Appears when articles are loading and shows a pulsing icon.
struct LaunchScreenView: View {

    /// Scale for the pulsing animation.
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        // Vertical stack for icon image and app name.
        VStack {
            Image("AppIconCodeUsage")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .onAppear {
                    // Trigger pulsing animation on appear.
                    withAnimation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true)
                    ) {
                        scale = 1.2 // Increase scale by 20%.
                    }
                }
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
