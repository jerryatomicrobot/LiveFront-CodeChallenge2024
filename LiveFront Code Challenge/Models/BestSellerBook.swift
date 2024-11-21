//
//  BestSellerBook.swift
//  LiveFront Code Challenge
//
//  Created by Jerry Baez on 11/19/24.
//

import Foundation

/// Represents a book item on the corresponding best seller list
struct BestSellerBook: Codable {

    // MARK: Constants

    let listName: String
    let displayName: String
    let bestSellersDateString: String
    let publishedDateString: String
    let rank: Int
    let rankLastWeek: Int
    let weeksOnList: Int
    let amazonProductUrlString: String
    let bookDetails: [BookDetails]

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
        case bookDetails = "book_details"
    }

    // mark: Computed Vars

    /// A date object that represents when this book became a best seller
    var bestSellersDate: Date? { self.getDateFromString(self.bestSellersDateString) }

    /// An URL object where this book can be seen in Amazon.com for purchase
    var amazonProductUrl: URL? { URL(string: self.amazonProductUrlString) }

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
