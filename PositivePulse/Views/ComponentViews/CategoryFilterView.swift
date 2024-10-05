//
//  CategoryFilterView.swift
//  PositivePulse
//
//  Created by Michelle Köhler on 12.08.24.
//

import SwiftUI

/// Displays filter categories as scrollable and clickable elements at the top.
struct CategoryFilterView: View {
    
    /// Observed instance of `NewsViewModelImpl`.
    @ObservedObject var viewModel: NewsViewModelImpl
    
    var body: some View {
        // Horizontal scroll view without indicators.
        ScrollView(.horizontal, showsIndicators: false) {
            // Horizontal stack to arrange categories.
            HStack(spacing: 20) {
                // Iterate through categories excluding 'all'.
                ForEach(FilterCategoryState.allCases.filter { $0 != .all }, id: \.self) { category in
                    VStack {
                        // Display category name.
                        Text(category.rawValue)
                            .fontWeight(.bold)
                            .onTapGesture {
                                // Update selected category and load new articles.
                                viewModel.selectedCategory = category
                                viewModel.loadNewArticles()
                            }
                            // Highlight selected category.
                            .foregroundColor(viewModel.selectedCategory == category ? Color.accentColor : Color.primary)
                            .padding([.leading, .trailing], 10)
                        
                        // Underline effect for selected category.
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(viewModel.selectedCategory == category ? Color.accentColor : .clear)
                            .padding(EdgeInsets(top: -5, leading: -10, bottom: 0, trailing: -10))
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
            .padding(.bottom, -3)
            .padding(.top, 17)
        }
    }
}
