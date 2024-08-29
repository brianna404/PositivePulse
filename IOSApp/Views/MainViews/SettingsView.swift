//
//  SettingsView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 26.08.24.
//

import SwiftUI

struct SettingsView: View {
    @State var selectedTheme = ThemeState.light
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Appearance", selection: $selectedTheme) {
                        ForEach(ThemeState.allCases, id: \.self) { theme in
                            Text(theme.rawValue)
                        }
                    }
                    Section
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
