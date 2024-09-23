//
//  DetailDataMapperTests.swift
//  MeliChallengeTests
//
//  Created by Andrés Carrillo on 23/09/24.
//

import XCTest
import MeliChallenge

final class DetailDataMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let jsonData = makeDetailJSON([:])
        let httpStatusCodesamples = [199, 201, 300, 400, 500]
        
        try httpStatusCodesamples.forEach { code in
            XCTAssertThrowsError(
                try DetailDataMapper.map(jsonData, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_deliversInvalidDataErrorOn200HTTPResponseWithEmptyData() {
        let emptyJsonData = makeDetailJSON([:])
        
        XCTAssertThrowsError(
            try DetailDataMapper.map(emptyJsonData, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversDetailItemOn200HTTPResponseWithValidJSON() throws {
        let item = makeItem(condition: "new", pictures: [anyURL()])
        
        let jsonData = makeDetailJSON(item.json)
        
        let result = try DetailDataMapper.map(jsonData, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, item.model)
    }
}

private extension DetailDataMapperTests {
    func makeItem(
        condition: String? = nil,
        pictures: [URL] = []
    ) -> (model: DetailItem, json: [String: Any]) {
        
        let itemDetail = DetailItem(
            condition: ItemCondition(rawValue: condition ?? "") ?? .noApply,
            images: pictures
        )
        
        let picturesJson = pictures.map { ["secure_url": $0.absoluteString] }
        
        let json: [String: Any] = [
            "condition": condition ?? "",
            "pictures": picturesJson
        ]
        
        return (itemDetail, json)
    }
}
