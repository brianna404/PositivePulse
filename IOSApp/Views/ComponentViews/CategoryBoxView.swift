//
//  CategoryBoxView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 25.08.24.
//

import SwiftUI

/// Displays a grid of category boxes for filtering articles.
struct CategoryBoxView: View {
    // MARK: - Properties
    
    /// Observed view model to handle category selection.
    @ObservedObject var viewModel: NewsViewModelImpl
    /// Binds the search text entered by the user.
    @Binding var searchText: String
    
    /// Selected font size for text elements.
    @AppStorage("selectedFontSize") private var selectedFontSize = FontSizeState.medium
    
    /// Two columns with flexible size for grid layout.
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    /// Returns the appropriate symbol for each category.
    func getSymbol(for category: FilterCategoryState) -> String {
        switch category {
        case .all:
            return "square.grid.2x2"
        case .general:
            return "globe"
        case .business:
            return "briefcase"
        case .entertainment:
            return "film"
        case .health:
            return "heart"
        case .science:
            return "flask"
        case .sports:
            return "sportscourt"
        case .technology:
            return "desktopcomputer"
        }
    }
    
    var body: some View {
        // Defines the grid layout to show all categories as clickable boxes.
        LazyVGrid(columns: columns, spacing: 16) {
            // Loop through all categories and create a button for each.
            ForEach(FilterCategoryState.allCases, id: \.self) { category in
                Button(action: {
                    viewModel.selectedCategory = category
                    if category == .all {
                        viewModel.searchInAllCategories(with: searchText)
                    }
                }) {
                    VStack {
                        // Display icon.
                        Image(systemName: getSymbol(for: category))
                            .font(.system(size: selectedFontSize.fontSizeCGFloat["title2"] ?? 20))
                            .foregroundColor(.white)
                        // Display category name.
                        Text(category.rawValue)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 4)
                    }
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .background(viewModel.selectedCategory == category ? Color.accentColor : Color.gray)
                    .cornerRadius(15)
                    .shadow(color: .gray, radius: 4, x: 0, y: 2)
                }
            }
        }
        .padding()
    }
}

#Preview {
    SearchView()
}
