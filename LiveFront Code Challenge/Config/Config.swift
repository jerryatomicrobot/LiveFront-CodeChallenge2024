//
//  Config.swift
//  LiveFront Code Challenge
//
//  Created by Jerry Baez on 11/18/24.
//

import Foundation

enum AppConfig {
    enum ConfigKey: String {
        case apiBaseUrl = "API_BASE_URL"
        case apiKey = "API_KEY"
        case apiAppId = "API_APP_ID"
        case apiSecret = "API_SECRET"
    }

    static var baseUri: String {
        "https://\(apiBaseUrl)"
    }

    /// API key to use when connecting to the API
    static var apiKey: String {
        stringValue(forKey: .apiKey)
    }

    /// API app id to use when connecting to the API
    static var apiAppId: String {
        stringValue(forKey: .apiKey)
    }

    /// API secret to use when connecting to the API
    static var apiSecret: String {
        stringValue(forKey: .apiSecret)
    }

    // MARK: Private vars

    /// Returns a string value from our config file
    /// - Parameter key: The key we want to read
    /// - Returns: String value
    private static func stringValue(forKey key: ConfigKey) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String else {
            assertionFailure("Invalid value or undefined key")
            return ""
        }
        return value
    }

    private static var apiBaseUrl: String {
        stringValue(forKey: .apiBaseUrl)
    }
}
