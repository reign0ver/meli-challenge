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
        case let .get(search):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path() + "/sites/MCO/search"
            components.queryItems = [
                URLQueryItem(name: "q", value: search),
                URLQueryItem(name: "limit", value: "10")
            ].compactMap { $0 }
            
            // we force it because otherwise it makes no sense to continue the execution
            // and we want the app to crash in dev environments to solve the error before it hits production
            return components.url!
        }
    }
}
