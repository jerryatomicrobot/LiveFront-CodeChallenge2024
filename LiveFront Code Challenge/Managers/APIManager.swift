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

// MARK: Classes

class APIManager {

    // MARK: - Vars and Constants

    var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    // MARK: - Endpoints

    enum EndpointType {
        case bestSellerList

        var urlPathString: String {
            switch self {
            case .bestSellerList:
                "/lists.json"
            }
        }
    }

    // MARK: Global URL Param Keys

    enum URLParamKey: String {
        case apiKey = "api-key"
    }
    // MARK: - Init Constants

    private let baseUrlString: String
    private let apiKey: String

    // MARK: - Inits

    init(baseUrlString: String, apiKey: String) {
        self.baseUrlString = baseUrlString
        self.apiKey = apiKey
    }

    // MARK: Request Methods

    // TODO: Add endpoint request methods

    // MARK: Utility Methods

    private func get(
        endpoint: EndpointType,
        acceptValue: String,
        contentTypeValue: String,
        additionalHeaders: [String:String] = [:],
        urlParameters: [String:String] = [:]
    ) throws -> URLRequest {

        guard let baseUrl = URL(string: baseUrlString + endpoint.urlPathString),
              var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
        else {
            throw URLError(.badURL)
        }

        var queryItems: [URLQueryItem] = urlParameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }

        queryItems.append(URLQueryItem(name: URLParamKey.apiKey.rawValue, value: apiKey))

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
