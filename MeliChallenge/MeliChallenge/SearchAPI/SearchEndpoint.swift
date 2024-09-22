//
//  SearchEndpoint.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 21/09/24.
//

import Foundation

public enum SearchEndpoint {
    case get(search: String)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(serch):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path() + "/search"
            components.queryItems = [
                URLQueryItem(name: "limit", value: "10")
                // TODO: Add the search text query item
            ].compactMap { $0 }
            
            // we force it because otherwise it makes no sense to continue the execution
            // and we want the app to crash in dev environments to solve the error before it hits production
            return components.url!
        }
    }
}
