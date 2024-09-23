//
//  DetailDataMapper.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 23/09/24.
//

import Foundation

public final class DetailDataMapper {
    public enum Error: Swift.Error {
        case invalidData
        case invalidHttpStatusCode
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> DetailItem {
        guard response.isOK else { throw Error.invalidHttpStatusCode }
        
        do {
            let root = try JSONDecoder().decode(RemoteDetailItem.self, from: data)
            return root.mappedItems
        } catch {
            print("\(DetailDataMapper.self) -> Error decoding the response data: \(error)")
            throw Error.invalidData
        }
    }
}

extension DetailDataMapper.RemoteDetailItem {
    var mappedItems: DetailItem {
        DetailItem(
            condition: ItemCondition(rawValue: condition ?? "") ?? .noApply,
            images: pictures
        )
    }
}
