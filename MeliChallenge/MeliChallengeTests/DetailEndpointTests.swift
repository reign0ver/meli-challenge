//
//  DetailEndpointTests.swift
//  MeliChallengeTests
//
//  Created by Andrés Carrillo on 23/09/24.
//

import XCTest
import MeliChallenge

final class DetailEndpointTests: XCTestCase {
    
    func test_detail_endpointURLWithSomeId_returnsExpectedURLWithPathParam() {
        let itemId = "MCO1147336698"
        let baseURL = URL(string: "http://base-url.com")!
        
        let receivedURL = DetailEndpoint.get(itemId: itemId).url(baseURL: baseURL)
        
        XCTAssertEqual(receivedURL.scheme, "http", "scheme")
        XCTAssertEqual(receivedURL.host, "base-url.com", "host")
        XCTAssertEqual(receivedURL.path, "/items/\(itemId)", "path")
    }
}
