//
//  ContentView.swift
//  LiveFront Code Challenge
//
//  Created by Jerry Baez on 11/18/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.apiManager) private var apiManager

    @State private var model = ContentViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            self.fetchBestSellerBooks()
        }
    }

    @MainActor private func fetchBestSellerBooks() {
        Task {
            do {
                model.performingFetchBooks = true

                let results = try await apiManager.getBestSellerBooks()

                switch results {
                case .success(let response):
                    model.books = response.results
                case .failure(let error):
                    print("Retrieve BestSellerBooks Error: \(error)")
                }

                model.performingFetchBooks = false
            } catch {
                print("Error prefetching BestSellerBooks data: \(String(describing: error))")
                model.performingFetchBooks = false
            }
        }
    }
}

#Preview {
    ContentView()
}
