//
//  SearchDataMapper.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 22/09/24.
//

import Foundation

public final class SearchDataMapper {
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private static var httpStatusCode200: Int { 200 }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws {
        guard response.statusCode == httpStatusCode200 else { throw Error.invalidData }
    }
}
