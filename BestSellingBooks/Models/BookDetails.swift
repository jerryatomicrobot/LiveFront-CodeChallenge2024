//
//  BookDetails.swift
//  LiveFront Code Challenge
//
//  Created by Jerry Baez on 11/19/24.
//

import Foundation

/// Represents the details of a book in a best seller list
struct BookDetails: Codable, Hashable {

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

// MARK: Extension

extension BookDetails {
    static var previewBook = BookDetails(
        title: "Test Book",
        description: "This is just a generic description.",
        contributor: "Joe Doe",
        author: "John Smith",
        contributorNote: "Just some testing notes.",
        price: "9.99",
        ageGroup: "",
        publisher: "Testing Publisher",
        primaryIsbn13: "999999999",
        primaryIsbn10: "888888888")
}
