//
//  CategoryBoxView.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 25.08.24.
//

import SwiftUI

struct CategoryBoxView: View {
    @ObservedObject var viewModel: NewsViewModelImpl
    @Binding var searchText: String
    
    // Use AppStorage for setting fontSize of text elements
    @AppStorage("selectedFontSize") private var selectedFontSize = FontSizeState.medium
    
    // create two columns with flexible size for grid layout
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // Get appropriate symbol for each category
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
    
    // Category grid boxes
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) { // vertical grid
            ForEach(FilterCategoryState.allCases, id: \.self) { category in // loop through all categories
                Button(action: {
                    viewModel.selectedCategory = category
                    if category == .all {
                        viewModel.searchInAllCategories(with: searchText)
                    }
                }) {
                    VStack {
                        Image(systemName: getSymbol(for: category))
                            .font(.system(size: selectedFontSize.fontSizeCGFloat["title2"] ?? 20))
                            .foregroundColor(.white)
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
