//
//  DetailItem.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 23/09/24.
//

import Foundation

public struct DetailItem: Equatable {
    private let condition: ItemCondition
    private let images: [URL]
    
    public init(condition: ItemCondition, images: [URL]) {
        self.condition = condition
        self.images = images
    }
}

public extension DetailItem {
    var formattedCondition: String? {
        switch condition {
        case .new: "Nuevo"
        case .used: "Usado"
        case .noApply: nil
        }
    }
    
    var imagesURL: [URL] { images }
}

public enum ItemCondition: String, Equatable {
    case new
    case used
    case noApply
}
