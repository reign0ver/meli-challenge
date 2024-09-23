//
//  RemoteCurrency.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 21/09/24.
//

extension SearchDataMapper {
    enum RemoteCurrency: String, Decodable {
        case cop = "COP"
        case unknown // TODO: Handle this error case
    }
}
