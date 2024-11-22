//
//  APIManager.swift
//  LiveFront Code Challenge
//
//  Created by Jerry Baez on 11/20/24.
//

import Foundation

// MARK: Global Enums

enum HTTPMethodType: String {
    case get = "GET"
}

enum HeaderType: String {
    case accept = "Accept"
    case contentType = "Content-Type"
}

enum MIMEType: String {
    case applicationJson = "application/json"
}

protocol APIManager {
    var jsonDecoder: JSONDecoder { get }

    func getBestSellerBooks() async throws -> Result<BestSellerResponse, URLError>
    func getThumbnailImageUrl(isbn: String) -> URL?
    func getBookCoverImageUrl(isbn: String) -> URL?
}

// MARK: Classes

class ProdAPIManager: APIManager {

    // MARK: - Vars and Constants

    var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    // MARK: - NY Times Endpoints

    enum EndpointType {
        case bestSellerList
        case thumbnailCover
        case bookCover

        var urlPathString: String {
            switch self {
            case .bestSellerList:
                "/lists.json"
            case .thumbnailCover:
                "/isbn/%@-S.jpg"
            case .bookCover:
                "/isbn/%@-M.jpg"
            }
        }
    }

    // MARK: NY Times URL Param Keys

    enum URLParamKey: String {
        case apiKey = "api-key"
    }

    enum BestSellerURLParamKey: String {
        case list = "list"
    }

    enum BestSellerListType: String {
        case hardcoverFiction = "hardcover-fiction"
        case paperbackNonfiction = "paperback-nonfiction"
    }

    // MARK: - Init Constants

    private let nytApiBaseUrlString: String
    private let nytKey: String
    private let olApiBaseUrlString: String

    // MARK: - Inits

    init(baseUrlString: String, apiKey: String, olApiBaseUrlString: String) {
        self.nytApiBaseUrlString = baseUrlString
        self.nytKey = apiKey
        self.olApiBaseUrlString = olApiBaseUrlString
    }

    // MARK: NY Times Request Methods

    func getBestSellerBooks() async throws -> Result<BestSellerResponse, URLError> {
        let request = try self.get(
            endpoint: .bestSellerList,
            acceptValue: MIMEType.applicationJson.rawValue,
            contentTypeValue: MIMEType.applicationJson.rawValue,
            urlParameters: [BestSellerURLParamKey.list.rawValue:BestSellerListType.hardcoverFiction.rawValue]
        )

        return await execute(request, expects: BestSellerResponse.self, decoder: jsonDecoder)
    }

    // MARK: OpenLibrary.org Utility Methods

    func getThumbnailImageUrl(isbn: String) -> URL? {
        let urlString = String(format: "https://" + olApiBaseUrlString + EndpointType.thumbnailCover.urlPathString, isbn)

        return URL(string: urlString)
    }

    func getBookCoverImageUrl(isbn: String) -> URL? {
        let urlString = String(format: "https://" + olApiBaseUrlString + EndpointType.bookCover.urlPathString, isbn)

        return URL(string: urlString)
    }

    // MARK: Utility Methods

    private func get(
        endpoint: EndpointType,
        acceptValue: String,
        contentTypeValue: String,
        additionalHeaders: [String:String] = [:],
        urlParameters: [String:String] = [:]
    ) throws -> URLRequest {

        guard let baseUrl = URL(string: nytApiBaseUrlString + endpoint.urlPathString),
              var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
        else {
            throw URLError(.badURL)
        }

        var queryItems: [URLQueryItem] = urlParameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }

        queryItems.append(URLQueryItem(name: URLParamKey.apiKey.rawValue, value: nytKey))

        components.queryItems = queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)

        request.httpMethod = HTTPMethodType.get.rawValue
        request.setValue(acceptValue, forHTTPHeaderField: HeaderType.accept.rawValue)
        request.setValue(contentTypeValue, forHTTPHeaderField: HeaderType.contentType.rawValue)

        additionalHeaders.forEach { header, value in
            request.setValue(value, forHTTPHeaderField: header)
        }

        return request
    }

    private func execute<Response: Codable>(
        _ request: URLRequest,
        expects type: Response.Type,
        decoder: JSONDecoder
    ) async -> Result<Response, URLError> {
        let requestCopy = request

        let startMs = Date.now

        do {
            print("API Request: \(requestCopy.httpMethod ?? "") \(requestCopy.url?.absoluteString ?? "")")

            let (data, response) = try await URLSession.shared.data(for: requestCopy)

            let endMs = Date.now
            let durationMs = Int(startMs.distance(to: endMs) * 1000)

            if let httpResponse = response as? HTTPURLResponse {
                print("API Response: \(requestCopy.httpMethod ?? "") \(requestCopy.url?.absoluteString ?? "") - \(httpResponse.statusCode) - \(durationMs)ms")
                return mapResult(type, data, httpResponse, decoder)
            }

            print("API Error: \(requestCopy.httpMethod ?? "") \(requestCopy.url?.absoluteString ?? "") - Unexpected URL response -  \(durationMs)ms")

            return Result.failure(URLError(.badServerResponse, userInfo: ["response": response]))
        } catch {
            let endMs = Date.now
            let durationMs = Int(startMs.distance(to: endMs) * 1000)

            print("API Error: \(requestCopy.httpMethod ?? "") \(requestCopy.url?.absoluteString ?? "") - \(error) - \(durationMs)ms")

            return Result.failure(URLError(.unknown, userInfo: ["localizedDescription": error.localizedDescription]))
        }
    }

    private func mapResult<Response: Codable>(
        _ type: Response.Type,
        _ data: Data,
        _ response: HTTPURLResponse,
        _ decoder: JSONDecoder
    ) -> Result<Response, URLError> {
        do {
            if response.statusCode >= 200 && response.statusCode <= 299 {
                let decoded = try decoder.decode(type, from: data)

                return Result.success(decoded)
            } else if response.statusCode == 401 {
                return Result.failure(URLError(.userAuthenticationRequired))
            } else {
                return Result.failure(URLError(.unknown))
            }
        } catch {
            return Result.failure(URLError(.unknown, userInfo: ["localizedDescription": error.localizedDescription]))
        }
    }
}
