//
//  BestSellingBooksApp.swift
//  BestSellingBooks
//
//  Created by Jerry Baez on 11/18/24.
//

import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {

    fileprivate let apiManager: ProdAPIManager

    override init() {

        self.apiManager = ProdAPIManager(
            baseUrlString: AppConfig.baseUrl,
            apiKey: AppConfig.apiKey,
            olApiBaseUrlString: AppConfig.olAPIBaseUrl
        )
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        return true
    }
}

@main
struct BestSellingBooksApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.apiManager, delegate.apiManager)
        }
    }
}

struct APIManagerKey: EnvironmentKey {
    static var defaultValue: ProdAPIManager {
        ProdAPIManager(baseUrlString: "", apiKey: "", olApiBaseUrlString: "")
    }
}

extension EnvironmentValues {
    var apiManager: ProdAPIManager {
        get { self[APIManagerKey.self] }
        set { self[APIManagerKey.self] = newValue }
    }
}
