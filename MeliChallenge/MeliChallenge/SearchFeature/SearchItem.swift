//
//  SearchItem.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 22/09/24.
//

import Foundation

public struct SearchItem {
    public let id: String
    private let imageURL: URL
    private let name: String
    private let price: PriceType
    private let currency: Currency
    private let numberOfInstallments: Int?
    private let priceOfEachInstallment: Double?
    private let freeShipping: Bool
    
    public init(
        id: String,
        imageURL: URL,
        name: String,
        price: PriceType,
        currency: Currency,
        numberOfInstallments: Int? = nil,
        priceOfEachInstallment: Double? = nil,
        freeShipping: Bool
    ) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.price = price
        self.currency = currency
        self.numberOfInstallments = numberOfInstallments
        self.priceOfEachInstallment = priceOfEachInstallment
        self.freeShipping = freeShipping
    }
}

// MARK: Identifiable conformance to work with SwiftUI List
// Discussion: SearchItem is a domain object. Create a new one that conforms Identifiable
// in the scope/namespace of SearchItemRow could've been better. But I'm happy this way for now.
extension SearchItem: Identifiable {}

extension SearchItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Extension that holds business logic related to formatting the data the View will display.
// Some of this logic should be better in a Presentation layer that maps this domain object
// into something like: SearchItemRow.ViewModel. But as I said, it's a tradeoff and I'm happy this way.
public extension SearchItem {
    var thumbnailURL: URL {
        // The response from the server returns a non-secure URL for the thumbnail (http instead of https protocol)
        // So we replace the scheme for https to be able to download the resource, otherwise we need to allow
        // non-secure requests in the app's Info.plist.
        guard var components = URLComponents(url: imageURL, resolvingAgainstBaseURL: false) else {
            return imageURL
        }
        components.scheme = "https"
        return components.url!
    }
    
    var title: String { name }
    
    var formattedPrice: (price: String, regularPrice: String?) {
        switch price {
        case .promotion(let price, let regularPrice):
            return (
                price.formatted(.currency(code: currency.currencyCode)),
                regularPrice.formatted(.currency(code: currency.currencyCode))
            )
        case .standard(let price):
            return (price.formatted(.currency(code: currency.currencyCode)), nil)
        }
    }
    
    var formattedInstallments: String? {
        guard let numberOfInstallments,
              let installmentPrice = priceOfEachInstallment else {
            return nil
        }
        let formattedInstallmentPrice = installmentPrice.formatted(.currency(code: currency.currencyCode))
        return "en \(numberOfInstallments) cuotas de \(formattedInstallmentPrice)"
    }
    
    var formattedFreeShipping: String? {
        freeShipping ? "¡Envío gratis!" : nil
    }
    
    var formattedDiscountPercentage: String? {
        if case .promotion(let price, let regularPrice) = price {
            let discountAmount = regularPrice - price
            let discountPercentage = (discountAmount / regularPrice) * 100
            let roundedPercentage = Int(discountPercentage.rounded())
            return "\(roundedPercentage)% OFF"
        } else {
            return nil
        }
    }
}

public enum Currency: String, Equatable {
    case cop = "COP"
    
    public var currencyCode: String { rawValue }
}

public enum PriceType: Equatable {
    case promotion(price: Double, regularPrice: Double)
    case standard(price: Double)
}
