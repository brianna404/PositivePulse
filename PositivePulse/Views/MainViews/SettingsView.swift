//
//  SettingsView.swift
//  PositivePulse
//
//  Created by Michelle Köhler on 26.08.24.
//

import SwiftUI

/// Displays editable settings for appearance and article loading options.
struct SettingsView: View {
    
    /// Observed view model instance.
    @ObservedObject var viewModel: NewsViewModelImpl
    
    /// Determines if dark mode is enabled.
    @AppStorage("isDarkMode") private var darkModeOn = false
    /// Selected font size for text elements.
    @AppStorage("selectedFontSize") private var selectedFontSize = FontSizeState.medium
    /// Selected country for news articles.
    @AppStorage("selectedCountry") private var selectedCountry = CountryState.unitedStates
    /// Preferred category for news articles.
    @AppStorage("selectedCategory") private var selectedCategory = FilterCategoryState.general
    
    var body: some View {
        // Form to structure settings options.
        Form {
            // Appearance Settings Section.
            Section {
                Text("Anzeige Einstellungen")
                    .font(.system(size: selectedFontSize.fontSizeCGFloat["headline"] ?? 17, weight: .bold))
                    .frame(alignment: .topLeading)
                
                Toggle("Dark Mode", isOn: $darkModeOn)
                
                Picker("Schriftgröße", selection: $selectedFontSize) {
                    ForEach(FontSizeState.allCases, id: \.self) { fontSize in
                        Text(fontSize.rawValue)
                    }
                }
            }
            // Article Settings Section.
            Section {
                Text("Artikel Einstellungen")
                    .font(.system(size: selectedFontSize.fontSizeCGFloat["headline"] ?? 17, weight: .bold))
                    .frame(alignment: .topLeading)
                
                Picker("Bevorzugte Kategorie", selection: $selectedCategory) {
                    ForEach(FilterCategoryState.allCases, id: \.self) { category in
                        Text(category.rawValue)
                    }
                }
                
                Picker("Land", selection: $selectedCountry) {
                    ForEach(CountryState.allCases, id: \.self) { country in
                        Text(country.rawValue)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: NewsViewModelImpl(service: NewsServiceImpl(), filterService: FilterServiceImpl()))
}
