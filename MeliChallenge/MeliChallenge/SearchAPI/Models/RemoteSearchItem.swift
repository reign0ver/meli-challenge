//
//  RemoteSearchItem.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 21/09/24.
//

import Foundation

extension SearchDataMapper {
    struct RemoteSearchItem: Decodable {
        let id: String
        let imageURL: URL
        let name: String
        let price: RemotePrice
        let currency: RemoteCurrency
        let installments: Installments?
        let freeShipping: Bool // custom container
        
        enum CodingKeys: String, CodingKey {
            case id
            case imageURL = "thumbnail"
            case name = "title"
            case price = "sale_price"
            case currency = "currency_id"
            case installments
            case freeShipping
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self.imageURL = try container.decode(URL.self, forKey: .imageURL)
            self.name = try container.decode(String.self, forKey: .name)
            self.price = try container.decode(RemotePrice.self, forKey: .price)
            self.currency = try container.decode(RemoteCurrency.self, forKey: .currency)
            self.installments = try container.decodeIfPresent(Installments.self, forKey: .installments)
            // TODO: Decode specific inner field 'shipping' and extract 'free_shipping' bool value
            self.freeShipping = try container.decodeIfPresent(Bool.self, forKey: .freeShipping) ?? false
        }
    }
}
