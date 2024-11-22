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
    @State private var presentedBooks: [BestSellerBook] = []

    var body: some View {
        NavigationStack(path: $presentedBooks) {
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
                List {
                    ForEach(model.books) {book in
                        NavigationLink {
                            DetailView(book: book)
                        } label: {
                            BookRow(book: book)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Top Selling Books")
                .padding()
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
