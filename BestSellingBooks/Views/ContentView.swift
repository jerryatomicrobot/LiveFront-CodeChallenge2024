//
//  ContentView.swift
//  LiveFront Code Challenge
//
//  Created by Jerry Baez on 11/18/24.
//

import SwiftUI

struct ContentView: View {

    // MARK: Inits

    init(model: ContentViewModel = ContentViewModel()) {
        self.model = model
    }

    // MARK: Vars

    @Environment(\.apiManager) private var apiManager

    @State private var model: ContentViewModel
    @State private var selection: BestSellerBook?

    var body: some View {
        NavigationSplitView {
            if model.performingFetchBooks {
                ProgressView()
            } else if model.books.isEmpty {
                VStack {
                    Spacer()

                    Text("Sorry, no Top Selling Books at the moment")

                    Spacer()
                }
                .padding()
            } else {
                List(model.books, selection: $selection) { book in
                    NavigationLink(value: book) {
                        BookRow(book: book)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Top Selling Books")
                .padding()
            }
        } detail: {
            if model.performingFetchBooks {
                ProgressView()
            } else if model.books.isEmpty {
                EmptyView()
            } else {
                if let book = selection {
                    DetailView(book: book)
                } else {
                    Text("Please select a book")
                }
            }
        }
        .onAppear {
            self.fetchBestSellerBooks()
        }
    }

    // MARK: Utility Methods

    @MainActor private func fetchBestSellerBooks() {
        Task {
            do {
                model.performingFetchBooks = true

                let results = try await apiManager.getBestSellerBooks()

                switch results {
                case .success(let response):
                    model.books = response.results.sorted(by: { $0.rank < $1.rank })
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

#Preview("NoBooks") {
    ContentView()
}

#Preview("Loading Books") {
    ContentView(model: ContentViewModel(books: [], performingFetchBooks: true))
}
