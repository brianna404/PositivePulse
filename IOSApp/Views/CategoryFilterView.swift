//
//  CategoryFilterView.swift
//  IOSApp
//
//  Created by Michelle Köhler on 12.08.24.
//

import SwiftUI

struct CategoryFilterView: View {
    @State private var selectedItem: FilterCategory? = .general
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
        HStack(spacing:20) {
            ForEach (FilterCategory.allCases, id: \.self) {
                category in
                    VStack {
                        Text(category.rawValue)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(selectedItem == category ? ColorScheme.fontColor: .black)
                            .onTapGesture {
                                selectedItem = category
                            }
                            .padding([.leading, .trailing], 10)
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(selectedItem == category ? ColorScheme.fontColor: .clear)
                            .padding(EdgeInsets(top: -5, leading: -10, bottom: 0, trailing: -10))
                            
                    }
                }
            }
            .background(Color.white)
            .padding(.bottom, -3)
        }
    }
}

#Preview {
    CategoryFilterView()
}
