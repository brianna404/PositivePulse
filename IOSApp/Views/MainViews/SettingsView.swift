//
//  SettingsView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 26.08.24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject
    var viewModel: NewsViewModelImpl
    @AppStorage("isDarkMode") private var darkModeOn = false
    @State private var selectedCountry = CountryState.germany
    @AppStorage("selectedLanguage") private var selectedLanguage = LanguageState.german
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Appearance Settings")
                        .font(.headline)
                        .frame(alignment: .topLeading)
                    Toggle("Dark Mode active", isOn: $darkModeOn)
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(LanguageState.allCases, id: \.self) { language in
                            Text(language.rawValue)
                        }
                    }
                }
            Section {
                Text("Article Settings")
                    .font(.headline)
                    .frame(alignment: .topLeading)
                Picker("Country", selection: $selectedCountry) {
                    ForEach(CountryState.allCases, id: \.self) { country in
                        Text(country.rawValue)
                            .onTapGesture {
                                viewModel.selectedCountryStrg = selectedCountry.filterValue
                            }
                    }
                }
            }
            }
        }
    }
}
#Preview {
    SettingsView(viewModel: NewsViewModelImpl(service: NewsServiceImpl(), filterService: FilterServiceImpl()))
}
