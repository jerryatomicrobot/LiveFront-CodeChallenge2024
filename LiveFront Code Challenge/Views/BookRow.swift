//
//  BookRow.swift
//  LiveFront Code Challenge
//
//  Created by Jerry Baez on 11/21/24.
//

import CachedAsyncImage
import SwiftUI

struct BookRow: View {
    let book: BestSellerBook?

    @Environment(\.apiManager) private var apiManager

    var body: some View {
        HStack {
            CachedAsyncImage(url: apiManager.getThumbnailImageUrl(isbn: book?.primaryDetails?.primaryIsbn10 ?? "")) { phase in
                switch phase {
                case .failure:
                    Image(systemName: "photo")
                case .success(let image):
                    image
                default:
                    ProgressView()
                }
            }
            .frame(width: 38, height: 58)

            Text(book?.primaryDetails?.title ?? "")
                .padding(.leading, 8)

            Spacer()

            Text("#\(book?.rank ?? 0)")
                .bold()
        }
        .padding()
    }
}

#Preview {
    BookRow(book: BestSellerBook.previewBook)
}
