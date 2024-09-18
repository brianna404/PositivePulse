//
//  IOSAppApp.swift
//  IOSApp
//
//  Created by Michelle Köhler on 28.06.24.
//

import SwiftUI

// MARK: - IOSApp Struct
// IOSApp defined as main entrypoint when opening the app

@main
struct IOSAppApp: App {
    
    // Use AppStorage for setting darkMode or lightMode in the app
    @AppStorage("isDarkMode") private var isDarkMode = false
    // Use AppStorage for setting fontSize of text elements
    @AppStorage("selectedFontSize") private var selectedFontSize = FontSizeState.medium
    
    var body: some Scene {
        // WindowGroup for defining content of user interface (ContentView)
        WindowGroup {
            ContentView()
            // Use color scheme of variable isDarkMode or default value LightMode
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .font(.system(size: selectedFontSize.fontSizeCGFloat["body"] ?? 17))
        }
    }
}
