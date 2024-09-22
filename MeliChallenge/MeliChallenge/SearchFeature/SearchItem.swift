//
//  SearchItem.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 22/09/24.
//

import Foundation

public struct SearchItem: Equatable {
    public let id: UUID
    public let imageURL: URL
    public let name: String
    public let price: PriceType
    public let currency: Currency
    public let numberOfInstallments: Int?
    public let priceOfEachInstallment: Double?
    public let freeShipping: Bool
    
    public var hasInstallments: Bool {
        numberOfInstallments != nil && priceOfEachInstallment != nil
    }
    
    public init(
        id: UUID,
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

public enum Currency: String, Equatable {
    case cop = "COP"
}

public enum PriceType: Equatable {
    case promotion(price: Double, regularPrice: Double)
    case standard(price: Double)
    
    public var isPromotion: Bool {
        // TODO: Awful and I think it's not needed. Check if can be deleted later
        if case .promotion = self {
            return true
        } else {
            return false
        }
    }
}
