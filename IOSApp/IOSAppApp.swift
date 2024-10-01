//
//  IOSAppApp.swift
//  IOSApp
//
//  Created by Michelle Köhler on 28.06.24.
//

import SwiftUI

/// Main entry point when opening the app.
@main
struct IOSAppApp: App {
    
    /// Determines if dark mode is enabled.
    @AppStorage("isDarkMode") private var isDarkMode = false
    /// Selected font size for text elements.
    @AppStorage("selectedFontSize") private var selectedFontSize = FontSizeState.medium
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Apply the selected color scheme.
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .font(.system(size: selectedFontSize.fontSizeCGFloat["body"] ?? 17))
        }
    }
}
