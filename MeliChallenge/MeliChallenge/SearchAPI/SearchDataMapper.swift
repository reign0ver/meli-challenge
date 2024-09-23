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
        case invalidHttpStatusCode
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [SearchItem] {
        guard response.isOK else { throw Error.invalidHttpStatusCode }
        
        do {
            let root = try JSONDecoder().decode(Root.self, from: data)
            return root.mappedItems
        } catch {
            print("Error decoding the response data: \(error)")
            throw Error.invalidData
        }
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
                    freeShipping: $0.freeShipping
                )
            }
        }
        
        private func mapPrice(_ price: RemotePrice) -> PriceType {
            if let regularPrice = price.regularAmount {
                return .promotion(price: price.amount, regularPrice: regularPrice)
            } else {
                return .standard(price: price.amount)
            }
        }
    }
}
