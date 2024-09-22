//
//  RemotePrice.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 21/09/24.
//
extension SearchDataMapper {
    struct RemotePrice: Decodable {
        let amount: Double
        let regularAmount: Double?
        
        private enum CodingKeys: String, CodingKey {
            case amount
            case regularAmount = "regular_amount"
        }
    }
}
