//
//  SearchDataMapper.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 22/09/24.
//

import Foundation

public final class SearchDataMapper {
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private static var httpStatusCode200: Int { 200 }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [SearchItem] {
        guard response.statusCode == httpStatusCode200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.mappedItems
    }
}

private extension SearchDataMapper {
    struct Root: Decodable {
        private let results: [RemoteSearchItem]
        
        var mappedItems: [SearchItem] {
            results.map {
                SearchItem(
                    id: $0.id,
                    imageURL: $0.imageURL,
                    name: $0.name,
                    price: mapPrice($0.price),
                    currency: Currency(rawValue: $0.currency.rawValue) ?? .cop,
                    numberOfInstallments: $0.installments?.numberOfInstallments,
                    priceOfEachInstallment: $0.installments?.priceOfEachInstallment,
                    freeShipping: true // TODO: Map the right value
                )
            }
        }
        
        private func mapPrice(_ price: RemotePrice) -> PriceType {
            switch price.content {
            case .promotion(let price):
                return .promotion(price: price.promotionAmount, regularPrice: price.regularAmount)
            case .standard(let price):
                return .standard(price: price.amount)
            case .unknown:
                return .standard(price: 0) // check this case and see if it worth it
            }
        }
    }
}
