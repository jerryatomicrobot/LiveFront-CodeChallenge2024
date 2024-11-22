//
//  DetailView.swift
//  LiveFront Code Challenge
//
//  Created by Jerry Baez on 11/21/24.
//

import CachedAsyncImage
import SwiftUI

struct DetailView: View {
    let book: BestSellerBook

    @Environment(\.apiManager) private var apiManager
    
    var body: some View {
        ScrollView {
            VStack {
                CachedAsyncImage(url: apiManager.getBookCoverImageUrl(isbn: book.primaryDetails?.primaryIsbn10 ?? "")) { phase in
                    switch phase {
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                    case .success(let image):
                        image
                    default:
                        ProgressView()
                    }
                }
                .padding(.bottom, 24)

                VStack(alignment: .leading) {
                    HStack {
                        Text("Title:")
                            .bold()
                        Text(book.primaryDetails?.title ?? "")

                    }
                    .padding(.bottom, 8)

                    Text("Description:")
                        .bold()
                    Text(book.primaryDetails?.description ?? "")
                        .padding(.bottom, 16)

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Author:")
                                .bold()
                            Text(book.primaryDetails?.author ?? "")
                        }

                        HStack {
                            Text("Publisher:")
                                .bold()
                            Text(book.primaryDetails?.publisher ?? "")
                        }

                        HStack {
                            Text("Release Date:")
                                .bold()
                            Text(book.formattedPublishedDateString)
                        }
                        .padding(.bottom, 16)

                        HStack {
                            Text("Best Seller Since:")
                                .bold()
                            Text(book.formattedBestSellerDateString)
                        }

                        HStack {
                            Text("Rank this week:")
                                .bold()
                            Text("#\(book.rank)")
                        }

                        HStack {
                            Text("Rank last week:")
                                .bold()
                            Text("#\(book.rankLastWeek)")
                        }
                    }
                    .padding(.bottom, 24)

                    Link("Buy it at Amazon!", destination: book.amazonProductUrl!)

                }
            }
        }
        .navigationTitle(book.primaryDetails?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
        .padding(.bottom)
    }
}

#Preview {
    DetailView(book: BestSellerBook.previewBook)
}
