//
//  CategoryFilterView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 12.08.24.
//

import SwiftUI

struct CategoryFilterView: View {
    @ObservedObject
    var viewModel: NewsViewModelImpl
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
        HStack(spacing:20) {
            ForEach (FilterCategory.allCases, id: \.self) {
                category in
                    VStack {
                        Text(category.rawValue)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .onTapGesture {
                                viewModel.selectedCategoryStrg = category.filterValue
                                viewModel.selectedCategory = category
                            }
                            .foregroundColor(viewModel.selectedCategory == category ? ColorScheme.fontColor: .black)
                            .padding([.leading, .trailing], 10)
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(viewModel.selectedCategory == category ? ColorScheme.fontColor: .clear)
                            .padding(EdgeInsets(top: -5, leading: -10, bottom: 0, trailing: -10))
                    }
                }
            }
            .background(Color.white)
            .padding(.bottom, -3)
        }
    }
}

