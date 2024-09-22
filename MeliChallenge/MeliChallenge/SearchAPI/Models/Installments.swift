//
//  Installments.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 21/09/24.
//

struct Installments: Decodable {
    let numberOfInstallments: Int
    let priceOfEachInstallment: Double
    
    private enum CodingKeys: String, CodingKey {
        case numberOfInstallments = "quantity"
        case priceOfEachInstallment = "amount"
    }
}
