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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
