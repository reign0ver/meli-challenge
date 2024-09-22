//
//  SearchItem.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 22/09/24.
//

import Foundation

public struct SearchItem {
    public let id: String
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
}

public enum Currency: String {
    case cop
}

public enum PriceType {
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
