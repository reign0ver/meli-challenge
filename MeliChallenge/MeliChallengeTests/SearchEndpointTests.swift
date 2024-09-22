//
//  SearchEndpointTests.swift
//  MeliChallengeTests
//
//  Created by Andrés Carrillo on 22/09/24.
//

import XCTest
import MeliChallenge

final class SearchEndpointTests: XCTestCase {
    
    func test_search_endpointURLWithSearchQueryParam() {
        let searchText = "magic mouse"
        let textWithPercentEncoding = "magic%20mouse"
        let baseURL = URL(string: "http://base-url.com")!
        
        let receivedURL = SearchEndpoint.get(search: searchText).url(baseURL: baseURL)
        
        XCTAssertEqual(receivedURL.scheme, "http", "scheme")
        XCTAssertEqual(receivedURL.host, "base-url.com", "host")
        XCTAssertEqual(receivedURL.path, "/sites/MCO/search", "path")
        XCTAssertEqual(receivedURL.query?.contains("q=\(textWithPercentEncoding)"), true, "q query param")
        XCTAssertEqual(receivedURL.query?.contains("limit=10"), true, "limit query param")
    }
}
