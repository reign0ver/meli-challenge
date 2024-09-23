//
//  SearchItemRow.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 22/09/24.
//

import SwiftUI

struct SearchItemRow: View {
    private let item: SearchItem
    
    init(item: SearchItem) {
        self.item = item
    }
    
    var body: some View {
        HStack {
            thumbnailImage
            descriptionView
        }
    }
    
    private var thumbnailImage: some View {
        AsyncImage(
            url: item.thumbnailURL,
            content: { image in
                image
            },
            placeholder: {
                ProgressView().id(UUID())
            }
        )
        .frame(width: 100, height: 100)
    }
    
    private var descriptionView: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.body)
                .lineLimit(3)
            
            Text("$ 478.813")
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SearchItemRow(
        item: .init(
            id: "some-id",
            imageURL: URL(string: "https://http2.mlstatic.com/D_831418-MLA74781058903_022024-I.jpg")!,
            name: "Apple Magic Mouse 2 Gris Espacial Model A1657",
            price: .standard(price: 100_000),
            currency: .cop,
            freeShipping: true
        )
    )
}
