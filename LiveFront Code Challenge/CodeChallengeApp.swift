//
//  CodeChallengeApp.swift
//  LiveFront Code Challenge
//
//  Created by Jerry Baez on 11/18/24.
//

import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {

    fileprivate let apiManager: APIManager

    override init() {

        self.apiManager = APIManager(baseUrlString: AppConfig.baseUrl, apiKey: AppConfig.apiKey)
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        return true
    }
}

extension AppDelegate {
    @MainActor fileprivate func prefetchBestSellerBooks() async -> [BestSellerBook] {
        do {
            let results = try await apiManager.getBestSellerBooks()

            switch results {
            case .success(let response):
                return response.results
            case .failure(let error):
                print("Retrieve BestSellerBooks Error: \(error)")
                return []
            }
        } catch {
            print("Error prefetching BestSellerBooks data: \(String(describing: error))")

            return []
        }
    }
}

@main
struct CodeChallengeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.apiManager, delegate.apiManager)
                .onAppear {
                    Task {
                        let books = await self.delegate.prefetchBestSellerBooks()
                        print("Books:\n", books)
                    }
                }
        }
    }
}

struct APIManagerKey: EnvironmentKey {
    static var defaultValue: APIManager {
        APIManager(baseUrlString: "", apiKey: "")
    }
}

extension EnvironmentValues {
    var apiManager: APIManager {
        get { self[APIManagerKey.self] }
        set { self[APIManagerKey.self] = newValue }
    }
}
