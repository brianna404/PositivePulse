//
//  CategoryBoxView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 25.08.24.
//

import SwiftUI

struct CategoryBoxView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: NewsViewModelImpl // observes changes in view model
    @Binding var searchText: String // binds the search text entered by user
    
    // Use AppStorage for setting fontSize of text elements
    @AppStorage("selectedFontSize") private var selectedFontSize = FontSizeState.medium
    
    // create two columns with flexible size for grid layout
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: Get symbol for category
    // returns appropriate symbol for each category
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
    
    // MARK: - Category Grid Boxes
    // defines the grid layout to show all categories as clickable boxes.
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) { // vertical grid with two columns
            // Loop through all categories and create a button for each
            ForEach(FilterCategoryState.allCases, id: \.self) { category in
                Button(action: {
                    viewModel.selectedCategory = category
                    if category == .all {
                        viewModel.searchInAllCategories(with: searchText)
                    }
                }) {
                    VStack {
                        Image(systemName: getSymbol(for: category)) // display icon
                            .font(.system(size: selectedFontSize.fontSizeCGFloat["title2"] ?? 20))
                            .foregroundColor(.white)
                        Text(category.rawValue) // display category name
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 4)
                    }
                    .frame(maxWidth: .infinity, minHeight: 120) // expand to fill available space
                    .background(viewModel.selectedCategory == category ? Color.accentColor : Color.gray) // color
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
