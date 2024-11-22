//
//  BestSellerBook.swift
//  LiveFront Code Challenge
//
//  Created by Jerry Baez on 11/19/24.
//

import Foundation

/// Represents a book item on the corresponding best seller list
struct BestSellerBook: Codable, Identifiable, Hashable {

    // MARK: Constants

    let id = UUID()

    let listName: String
    let displayName: String
    let bestSellersDateString: String
    let publishedDateString: String
    let rank: Int
    let rankLastWeek: Int
    let weeksOnList: Int
    let amazonProductUrlString: String
    let details: [BookDetails]

    // MARK: Enums

    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case displayName = "display_name"
        case bestSellersDateString = "bestsellers_date"
        case publishedDateString = "published_date"
        case rank
        case rankLastWeek = "rank_last_week"
        case weeksOnList = "weeks_on_list"
        case amazonProductUrlString = "amazon_product_url"
        case details = "book_details"
    }

    // MARK: Computed Vars

    var primaryDetails: BookDetails? { self.details.first }

    /// A date object that represents when this book became a best seller
    var bestSellersDate: Date? { self.getDateFromString(self.bestSellersDateString) }

    /// A `bestSellersDate` string in the format expected at the `DetailsView`
    var formattedBestSellerDateString: String {
        guard let bestSellersDate else { return "" }

        return bookDateFormatter.string(from: bestSellersDate)
    }

    /// A date object that represents when this book was released
    var publishedDate: Date? { self.getDateFromString(self.publishedDateString) }
    
    /// A `publishedDate` string in the format expected at the `DetailsView`
    var formattedPublishedDateString: String {
        guard let publishedDate else { return "" }

        return bookDateFormatter.string(from: publishedDate)
    }

    /// An URL object where this book can be seen in Amazon.com for purchase
    var amazonProductUrl: URL? { URL(string: self.amazonProductUrlString) }
    
    /// Returns a `DateFormatter` instance that has the correct date format for the book-related dates to be displayed on the `DetailsView`
    private var bookDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = .medium

        return dateFormatter
    }

    // MARK: Utility Methods

    /// Returns a Date object based on the given string (NOTE: The string format must be "yyyy-MM-dd" for this method to return a valid Date object)
    /// - Parameter dateString: The string representing a data in "yyyy-MM-dd" format
    /// - Returns: A Data object representing the given "yyyy-MM-dd" formatted string
    private func getDateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter.date(from: dateString)
    }
}

// MARK: Extension

extension BestSellerBook {
    static var previewBook = BestSellerBook(
        listName: "Test List",
        displayName: "Test List",
        bestSellersDateString: "2024-11-21",
        publishedDateString: "2024-11-21",
        rank: 1,
        rankLastWeek: 1,
        weeksOnList: 2,
        amazonProductUrlString: "https://a.co/d/ezLIcvp",
        details: [BookDetails.previewBook]
    )
}
