//
//  Currency.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 21/09/24.
//

extension SearchDataMapper {
    enum Currency: String, Decodable {
        case cop = "COP"
        case unknown // Handle this error case
    }
}
