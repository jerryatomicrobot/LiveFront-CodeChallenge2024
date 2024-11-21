//
//  ContentViewModel.swift
//  LiveFront Code Challenge
//
//  Created by Jerry Baez on 11/21/24.
//

import Foundation

@Observable class ContentViewModel {

    // MARK: Vars

    var books: [BestSellerBook] = []
    var performingFetchBooks: Bool = false
}
