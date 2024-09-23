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
        let freeShipping: Bool
        
        private enum CodingKeys: String, CodingKey {
            case id
            case imageURL = "thumbnail"
            case name = "title"
            case price = "sale_price"
            case currency = "currency_id"
            case installments
            case shipping
        }
        
        private enum ShippingCodingKeys: String, CodingKey {
            case freeShipping = "free_shipping"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let innerContainer = try container.nestedContainer(keyedBy: ShippingCodingKeys.self, forKey: .shipping)
            
            id = try container.decode(String.self, forKey: .id)
            imageURL = try container.decode(URL.self, forKey: .imageURL)
            name = try container.decode(String.self, forKey: .name)
            price = try container.decode(RemotePrice.self, forKey: .price)
            currency = try container.decode(RemoteCurrency.self, forKey: .currency)
            installments = try container.decodeIfPresent(Installments.self, forKey: .installments)
            freeShipping = try innerContainer.decode(Bool.self, forKey: .freeShipping)
        }
    }
}
