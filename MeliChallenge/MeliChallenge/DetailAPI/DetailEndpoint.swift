//
//  DetailEndpoint.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 23/09/24.
//

import Foundation

public enum DetailEndpoint {
    case get(itemId: String)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(itemId):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path() + "/items/\(itemId)"
            return components.url!
        }
    }
}
