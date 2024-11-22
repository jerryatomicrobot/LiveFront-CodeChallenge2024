//
//  BestSellingBooksTests.swift
//  BestSellingBooksTests
//
//  Created by Jerry Baez on 11/22/24.
//

import XCTest
@testable import BestSellingBooks

final class BestSellingBooksTests: XCTestCase {

    let mockApiManager = TestAPIManager()

    func testGetBestSellerBooks() async throws {
            do {
                let results = try await mockApiManager.getBestSellerBooks()

                let books: [BestSellerBook]
                switch results {
                case .success(let response):
                    books = response.results.sorted(by: { $0.rank < $1.rank })

                    XCTAssertFalse(books.isEmpty)
                    XCTAssertNotNil(books)

                    let topFirstBook = books.first
                    XCTAssertNotNil(topFirstBook, "We got a valid Top #1 book.")
                    XCTAssertNotNil(topFirstBook?.primaryDetails, "We got a valid `BookDetails` object from the Top #1 book.")
                case .failure:
                    XCTFail("Best Seller Books results failed")
                }
            } catch {
                XCTFail("Best Seller Books results are incorrect or decoding failed")
            }
        }

        func testGetThumbnailImageUrl() {
            let url = mockApiManager.getThumbnailImageUrl(isbn: "1538757907")

            XCTAssertEqual(url, URL(string: TestAPIManager.testThumbnailUrlString))
        }

        func testGetBookCoverImageUrl() {
            let url = mockApiManager.getBookCoverImageUrl(isbn: "1538757907")

            XCTAssertEqual(url, URL(string: TestAPIManager.testBookCoverUrlString))
        }
}
