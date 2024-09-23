//
//  DetailView.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 23/09/24.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject private var vm: DetailViewModel
    
    init(vm: DetailViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        VStack {
            switch vm.state {
            case .loading: 
                ProgressView()
            case let .loaded(item, detailItem):
                getMainView(item, detailItem)
            case .error:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear(perform: vm.onAppear)
    }
    
    private func getMainView(_ item: SearchItem, _ detailItem: DetailItem) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                getHeaderTitle(detailItem.formattedCondition, item.title)
                
                if let firstImageURL = detailItem.imagesURL.first {
                    getFirstImage(firstImageURL)
                }
                
                getPriceView(
                    regularPrice: item.formattedPrice.regularPrice,
                    price: item.formattedPrice.price,
                    discount: item.formattedDiscountPercentage
                )
                getInstallmentsInfoView(item.formattedInstallments)
            }
            .padding(.top, 24)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
        }
    }
    
    private func getHeaderTitle(_ condition: String?, _ title: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let condition {
                Text(condition)
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
                    .lineLimit(1)
            }
            
            Text(title)
                .font(.body)
                .foregroundStyle(Color.primary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func getFirstImage(_ imageURL: URL) -> some View {
        VStack(alignment: .center) {
            AsyncImage(
                url: imageURL,
                content: { image in
                    image
                        .resizable()
                        .scaledToFit()
                },
                placeholder: {
                    ProgressView()
                }
            )
            .padding()
            .containerRelativeFrame(
                [.horizontal, .vertical],
                alignment: .center
            ) { value, axis in
                switch axis {
                case .horizontal: value * 0.8
                case .vertical: value * 0.4
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func getPriceView(
        regularPrice: String?,
        price: String,
        discount: String?
    ) -> some View {
        
        VStack(alignment: .leading) {
            if let regularPrice {
                Text(regularPrice)
                    .strikethrough()
                    .font(.body)
                    .foregroundStyle(Color.secondary)
                    .lineLimit(1)
            }
            
            HStack(alignment: .center, spacing: 8) {
                Text(price)
                    .font(.title)
                    .foregroundStyle(Color.primary)
                    .lineLimit(1)
                
                if let discount {
                    Text(discount)
                        .font(.subheadline)
                        .foregroundStyle(Color.green)
                        .lineLimit(1)
                }
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func getInstallmentsInfoView(_ installmentsInfo: String?) -> some View {
        if let installmentsInfo {
            Text(installmentsInfo)
                .font(.body)
                .foregroundStyle(Color.primary)
                .lineLimit(1)
        }
    }
}

#if DEBUG
#Preview {
    DetailView(
        vm: DetailViewModel(
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
    )
}
#endif
