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
        HStack(alignment: .center, spacing: 8) {
            thumbnailImage
            descriptionView
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
    
    private var thumbnailImage: some View {
        AsyncImage(
            url: item.thumbnailURL,
            content: { image in
                image.resizable()
            },
            placeholder: {
                ProgressView().id(UUID())
            }
        )
        .frame(width: 100, height: 100)
    }
    
    private var descriptionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            titleView
            priceView
            installmentsInfoView
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var titleView: some View {
        Text(item.title)
            .font(.body)
            .foregroundStyle(Color.primary)
            .lineLimit(3)
    }
    
    private var priceView: some View {
        VStack(alignment: .leading) {
            if let regularPrice = item.formattedPrice.regularPrice {
                Text(regularPrice)
                    .strikethrough()
                    .font(.callout)
                    .foregroundStyle(Color.secondary)
                    .lineLimit(1)
            }
            
            Text(item.formattedPrice.price)
                .font(.title3)
                .foregroundStyle(Color.primary)
                .lineLimit(1)
        }
    }
    
    @ViewBuilder
    private var installmentsInfoView: some View {
        if let installments = item.formattedInstallments {
            Text(installments)
                .font(.callout)
                .foregroundStyle(Color.primary)
                .lineLimit(1)
        }
    }
}

#if DEBUG
#Preview {
    SearchItemRow(
        item: .init(
            id: "some-id",
            imageURL: URL(string: "https://http2.mlstatic.com/D_831418-MLA74781058903_022024-I.jpg")!,
            name: "Apple Magic Mouse 2 Gris Espacial Model A1657",
            price: .promotion(price: 100_000, regularPrice: 150_000),
            currency: .cop,
            numberOfInstallments: 6,
            priceOfEachInstallment: 199_990,
            freeShipping: true
        )
    )
}
#endif
