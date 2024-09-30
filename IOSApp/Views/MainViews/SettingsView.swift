//
//  SettingsView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 26.08.24.
//

import SwiftUI

// MARK: - SettingsView Struct
// Shows editable settings for appearance and article loading options

struct SettingsView: View {
    
    // Observed object from provided parameter
    @ObservedObject
    var viewModel: NewsViewModelImpl
    
    // Usage of AppStorage for global access to settings options
    @AppStorage("isDarkMode") private var darkModeOn = false
    @AppStorage("selectedLanguage") private var selectedLanguage = LanguageState.german
    @AppStorage("selectedFontSize") private var selectedFontSize = FontSizeState.medium
    @AppStorage("selectedCountry") private var selectedCountry =  CountryState.germany
    @AppStorage("selectedCategory") private var selectedCategory = FilterCategoryState.general
    
    @State private var preferedSources = ""
    
    var body: some View {
        
        // Form for structuring elements that are entered by the user
        Form {
            // Section for visible sectioning of different setting options
            Section {
                Text("Anzeige Einstellungen")
                    .font(.system(size: selectedFontSize.fontSizeCGFloat["headline"] ?? 17, weight: .bold))
                    .frame(alignment: .topLeading)
                
                Toggle("Dark Mode", isOn: $darkModeOn)
                
                Picker("Sprache", selection: $selectedLanguage) {
                    // Iterating through LanguageStates for showing all stages in rawValue
                    ForEach(LanguageState.allCases, id: \.self) { language in
                        
                        Text(language.rawValue)
                    }
                }
                
                Picker("Schriftgröße", selection: $selectedFontSize) {
                    // Iterating through FontSizeStates for showing all stages in rawValue
                    ForEach(FontSizeState.allCases, id: \.self) { fontSize in
                        
                        Text(fontSize.rawValue)
                    }
                }
            }
            
            Section {
                Text("Artikel Einstellungen")
                    .font(.system(size: selectedFontSize.fontSizeCGFloat["headline"] ?? 17, weight: .bold))
                    .frame(alignment: .topLeading)
                
                // this function is not functional in this version!!
                TextField(
                        "Bevorzugte Quellen",
                        text: $preferedSources
                    )
                
                // Iterating through FilterCategoryStates for showing all stages in rawValue
                Picker("Bevorzugte Kategorie", selection: $selectedCategory) {
                    ForEach(FilterCategoryState.allCases, id: \.self) { category in
                        
                        Text(category.rawValue)
                    }
                }
                
                // Iterating through countryStates for showing all stages in rawValue
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
