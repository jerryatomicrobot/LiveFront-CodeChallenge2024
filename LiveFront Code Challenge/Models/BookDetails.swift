//
//  BookDetails.swift
//  LiveFront Code Challenge
//
//  Created by Jerry Baez on 11/19/24.
//

import Foundation

/// Represents the details of a book in a best seller list
struct BookDetails: Codable {

    // MARK: Constants

    let title: String
    let description: String
    let contributor: String
    let author: String
    let contributorNote: String
    let price: String
    let ageGroup: String
    let publisher: String
    let primaryIsbn13: String
    let primaryIsbn10: String

    // MARK: Enums
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case contributor
        case author
        case contributorNote = "contributor_note"
        case price
        case ageGroup = "age_group"
        case publisher
        case primaryIsbn13 = "primary_isbn13"
        case primaryIsbn10 = "primary_isbn10"
    }
}
