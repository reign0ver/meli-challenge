//
//  SearchDataMapperTests.swift
//  MeliChallengeTests
//
//  Created by Andrés Carrillo on 21/09/24.
//

import XCTest
import MeliChallenge

final class SearchDataMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let jsonData = makeItemsJSON([])
        let httpStatusCodesamples = [199, 201, 300, 400, 500]
        
        try httpStatusCodesamples.forEach { code in
            XCTAssertThrowsError(
                try SearchDataMapper.map(jsonData, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try SearchDataMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])
        
        let result = try SearchDataMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(id: UUID(), imageURL: anyURL(), name: "Apple Magic Mouse", price: 350_000, currency: "COP")
        let item2 = makeItem(id: UUID(), imageURL: anyURL(), name: "Playseat F1 Seat", price: 7_500_000, currency: "COP")
        
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try SearchDataMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
}

// MARK: - Helpers
private extension SearchDataMapperTests {
    func makeItem(
        id: UUID,
        imageURL: URL = URL(string: "http://a-url.com")!,
        name: String = "",
        price: Double = 10_000,
        regularPrice: Double? = nil,
        currency: String = "COP",
        numberOfInstallments: Int? = nil,
        priceOfEachInstallment: Double? = nil,
        freeShipping: Bool = false
    ) -> (model: SearchItem, json: [String: Any]) {
        let item = SearchItem(
            id: id,
            imageURL: imageURL,
            name: name,
            price: PriceType.standard(price: price),
            currency: Currency(rawValue: currency) ?? .cop,
            numberOfInstallments: numberOfInstallments,
            priceOfEachInstallment: priceOfEachInstallment,
            freeShipping: freeShipping
        )
        
        let json: [String: Any] = [
            "id": id.uuidString,
            "thumbnail": imageURL.absoluteString,
            "title": name,
            "sale_price": [
                "amount": price,
                "regular_amount": regularPrice
            ],
            "currency_id": "COP",
            "installments": getInstallments(),
            "shipping": [
                "free_shipping": freeShipping
            ]
        ].compactMapValues { $0 }
        
        return (item, json)
    }
    
    private func getInstallments(
        numberOfInstallments: Int? = nil,
        priceOfEachInstallment: Double? = nil
    ) -> [String: Any]? {
        guard let numberOfInstallments, let priceOfEachInstallment else { return nil }
        
        return [
            "quantity": numberOfInstallments,
            "amount": priceOfEachInstallment
        ]
    }
}
