//
//  CategoryFilterView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 12.08.24.
//

import SwiftUI

// MARK: - CategoryFilterView Struct
// Shows possible filter categories as scrollable and clickable elements at the top
struct CategoryFilterView: View {
    
    // MARK: - Attributes
    // Observe instance of provided NewsViewModelImpl
    @ObservedObject
    var viewModel: NewsViewModelImpl
    
    var body: some View {
        // Make view scrollable in horizontal direction
        // Hide bar to indicate at which position has been scrolled
        ScrollView (.horizontal, showsIndicators: false) {
            
        // Sort categories horizontally
        HStack(spacing: 20) {
            // Iterate through categories in FilterCategoryState
            ForEach (FilterCategoryState.allCases, id: \.self) {
                category in
                    // Style Text of Category with colored underline
                    VStack {
                        // Show readable name of category
                        Text(category.rawValue)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            // Update related categoryFilter values in observed viewModel
                            .onTapGesture {
                                // Use filterValue of enum value for providing string readable for api
                                viewModel.selectedCategoryStrg = category.filterValue
                                viewModel.selectedCategory = category
                            }
                            // If category selected it is highlighted otherwise default color for showing differently in darkMode and LightMode
                            .foregroundColor(viewModel.selectedCategory == category ? Color.accentColor: Color.primary)
                            .padding([.leading, .trailing], 10)
                        
                        // Creates underline effect under category-text
                        Rectangle()
                            .frame(height: 2)
                            // If category selected it is highlighted otherwise default color for showing differently in darkMode and LightMode
                            .foregroundColor(viewModel.selectedCategory == category ? Color.accentColor: .clear)
                            .padding(EdgeInsets(top: -5, leading: -10, bottom: 0, trailing: -10))
                    }
                }
            }
            // Default background color to differentiate between DarkMode and LightMode
            .background(Color(UIColor.systemBackground))
            .padding(.bottom, -3)
            .padding(.top, 17)
        }
    }
}
