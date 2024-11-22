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
//                        BookRow(bookDetails: book.primaryDetails)
                        NavigationLink(book.primaryDetails?.title ?? "", value: book)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Top Selling Books")
                .padding()
                .navigationDestination(for: BestSellerBook.self) { book in
                    
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

#Preview("NoBooks") {
    ContentView()
}

#Preview("Loading Books") {
    ContentView(model: ContentViewModel(books: [], performingFetchBooks: true))
}
