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
        let item1 = makeItem(
            id: "some-id",
            imageURL: anyURL(),
            name: "Apple Magic Mouse",
            price: 350_000,
            currency: "COP",
            freeShipping: true
        )
        let item2 = makeItem(
            id: "some-another-id",
            imageURL: anyURL(),
            name: "Playseat F1 Seat",
            price: 7_500_000,
            currency: "COP",
            freeShipping: false
        )
        
        let jsonData = makeItemsJSON([item1.json, item2.json])
        
        let result = try SearchDataMapper.map(jsonData, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    func test_format_whenItemHasPromotionPriceAndCurrencyIsCOP_thenAssertsTheExpectedFormattedPrice() {
        let item = makeItem(
            id: "some-id",
            price: 450_000,
            regularPrice: 590_000,
            currency: "COP"
        )
        let model = item.model
        // Formatter adds a non breaking space between the currency symbol and the amount
        // '\u{00a0}' is the way Swift represents the especial character.
        // See https://developer.apple.com/forums/thread/5868
        let expectedFormattedPrice = (price: "$\u{00a0}450.000", regularPrice: "$\u{00a0}590.000")
        
        XCTAssertEqual(model.formattedPrice.price, expectedFormattedPrice.price)
        XCTAssertEqual(model.formattedPrice.regularPrice, expectedFormattedPrice.regularPrice)
    }
    
    func test_format_whenItemHasInstallments_thenAssertsTheExpectedFormattedText() {
        let item = makeItem(id: "some-id", numberOfInstallments: 6, priceOfEachInstallment: 134_490)
        let model = item.model
        
        let expectedFormattedText = "en 6 cuotas de $\u{00a0}134.490"
        
        XCTAssertEqual(model.formattedInstallments, expectedFormattedText)
    }
    
    func test_format_whenItemHasFreeShipping_thenAssertsFreeShippingFormattedText() {
        let item = makeItem(id: "some-id", freeShipping: true)
        let model = item.model
        
        let expectedFormattedText = "¡Envío gratis!"
        
        XCTAssertEqual(model.formattedFreeShipping, expectedFormattedText)
    }
    
    func test_format_whenItemHasNoFreeShipping_thenFreeShippingFormattedTextIsNil() {
        let item = makeItem(id: "some-id", freeShipping: false)
        let model = item.model
        
        XCTAssertNil(model.formattedFreeShipping)
    }
}

// MARK: - Helpers
private extension SearchDataMapperTests {
    func makeItem(
        id: String,
        imageURL: URL = URL(string: "http://a-url.com")!,
        name: String = "",
        price: Double = 10_000,
        regularPrice: Double? = nil,
        currency: String = "COP",
        numberOfInstallments: Int? = nil,
        priceOfEachInstallment: Double? = nil,
        freeShipping: Bool = false
    ) -> (model: SearchItem, json: [String: Any]) {
        
        let priceType: PriceType
        if let regularPrice {
            priceType = .promotion(price: price, regularPrice: regularPrice)
        } else {
            priceType = .standard(price: price)
        }
        
        let item = SearchItem(
            id: id,
            imageURL: imageURL,
            name: name,
            price: priceType,
            currency: Currency(rawValue: currency) ?? .cop,
            numberOfInstallments: numberOfInstallments,
            priceOfEachInstallment: priceOfEachInstallment,
            freeShipping: freeShipping
        )
        
        let json: [String: Any] = [
            "id": id,
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
