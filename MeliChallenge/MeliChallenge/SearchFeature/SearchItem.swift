//
//  SearchItem.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 22/09/24.
//

import Foundation

public struct SearchItem: Equatable {
    private let id: String
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

public extension SearchItem {
    var thumbnailURL: URL { imageURL }
    
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
}

public enum Currency: String, Equatable {
    case cop = "COP"
    
    public var currencyCode: String { rawValue }
}

public enum PriceType: Equatable {
    case promotion(price: Double, regularPrice: Double)
    case standard(price: Double)
}
