//
//  TestAPIManager.swift
//  LiveFront Code Challenge
//
//  Created by Jerry Baez on 11/21/24.
//

import Foundation

class TestAPIManager: APIManager {
    let testThumbnailUrlString = "https://covers.openlibrary.org/b/isbn/1538757907-S.jpg"
    let testBookCoverUrlString = "https://covers.openlibrary.org/b/isbn/1538757907-M.jpg"

    var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    func getBestSellerBooks() async throws -> Result<BestSellerResponse, URLError> {
        let location = Bundle.main.url(forResource: "BestSellerList", withExtension: "json")!

        let data = try await URLSession.shared.data(from: location).0
        let response = try JSONDecoder().decode(BestSellerResponse.self, from: data)
        return Result.success(response)
    }
    
    func getThumbnailImageUrl(isbn: String) -> URL? {
        URL(string: testThumbnailUrlString)
    }
    
    func getBookCoverImageUrl(isbn: String) -> URL? {
        URL(string: testBookCoverUrlString)
    }
}
