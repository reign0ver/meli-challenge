//
//  SharedTestsHelpers.swift
//  MeliChallengeTests
//
//  Created by Andrés Carrillo on 22/09/24.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func makeItemsJSON(_ items: [[String: Any]]) -> Data {
    let json = ["results": items]
    return try! JSONSerialization.data(withJSONObject: json)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
