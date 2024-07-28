//
//  ResultState.swift
//  IOSApp
//
//  Created by Michelle Köhler on 27.07.24.
//

import Foundation

enum ResultState {
    case loading
    case success(content: [Article])
    case failed(error: Error)
}
