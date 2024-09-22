//
//  Price.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 21/09/24.
//

struct Price: Decodable {
    // We don't want to make this property available since it is used just
    // to decode the type property, evaluate it and assign dynamically the content property.
    private let type: String
    let content: PriceContent
    
    private enum CodingKeys: CodingKey {
        case type
        case content
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "promotion":
            let content = try container.decode(PromotionPrice.self, forKey: .content)
            self.content = .promotion(content)
        case "standard":
            let content = try container.decode(StandardPrice.self, forKey: .content)
            self.content = .standard(content)
        default:
            content = .unknown
        }
    }
}

enum PriceContent: Decodable {
    case promotion(PromotionPrice)
    case standard(StandardPrice)
    case unknown
}

struct PromotionPrice: Decodable {
    let promotionAmount: Double
    let regularAmount: Double
    
    private enum CodingKeys: String, CodingKey {
        case promotionAmount = "amount"
        case regularAmount = "regular_amount"
    }
}

struct StandardPrice: Decodable {
    let amount: Double
}
