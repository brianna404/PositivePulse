//
//  IOSAppApp.swift
//  IOSApp
//
//  Created by Michelle Köhler on 28.06.24.
//

import SwiftUI

@main
struct IOSAppApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
