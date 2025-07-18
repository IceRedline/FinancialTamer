//
//  FinancialTamerTests.swift
//  FinancialTamerTests
//
//  Created by Артем Табенский on 10.06.2025.
//

import XCTest
@testable import FinancialTamer

final class FinancialTamerTests: XCTestCase {
    
    func jsonString(from object: Any) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys])
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "JSONConversion", code: 1, userInfo: nil)
        }
        return jsonString
    }

    func testJSONObject() throws {
        
        let dateExample = Date(timeIntervalSinceReferenceDate: 0)
        
        let testTransaction = Transaction(
          id: 1,
          account: Account(id: 1, userId: 1, name: "Artyom", balance: 1000, currency: "$", createdAt: dateExample, updatedAt: dateExample),
          category: Category(id: 1, name: "categorytest", emoji: "✅", isIncome: .income),
          amount: 30.0,
          transactionDate: dateExample,
          comment: "",
          createdAt: dateExample,
          updatedAt: dateExample
        )

        let resultJsonDictionary = testTransaction.jsonObject

        let correctJSONDict: [String : Any] = [
            "id": 1,
            "amount": "30.0",
            "transactionDate": "2001-01-01T00:00:00.000Z",
            "comment": "",
            "createdAt": "2001-01-01T00:00:00.000Z",
            "updatedAt": "2001-01-01T00:00:00.000Z",
            "category": [
                "id": 1,
                "name": "categorytest",
                "emoji": "✅",
                "isIncome": true
            ],
            "account": [
                "id": 1,
                "userId": 1,
                "name": "Artyom",
                "balance": "1000",
                "currency": "$",
                "createdAt": "2001-01-01T00:00:00.000Z",
                "updatedAt": "2001-01-01T00:00:00.000Z"
            ]
        ]
        
        let resultString = try jsonString(from: resultJsonDictionary)
        let correctString = try jsonString(from: correctJSONDict)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    func testParse() throws {
        
        let dateExample = Date(timeIntervalSinceReferenceDate: 0)

        let testJSONDict: [String : Any] = [
            "id": 1,
            "amount": "30.0",
            "transactionDate": "2001-01-01T00:00:00.000Z",
            "comment": "",
            "createdAt": "2001-01-01T00:00:00.000Z",
            "updatedAt": "2001-01-01T00:00:00.000Z",
            "category": [
                "id": 1,
                "name": "categorytest",
                "emoji": "✅",
                "isIncome": true
            ],
            "account": [
                "id": 1,
                "userId": 1,
                "name": "Artyom",
                "balance": "1000",
                "currency": "$",
                "createdAt": "2001-01-01T00:00:00.000Z",
                "updatedAt": "2001-01-01T00:00:00.000Z"
            ]
        ]

        let resultTransaction = Transaction.parse(jsonObject: testJSONDict)
        
        let correctTransaction = Transaction(
            id: 1,
            account: Account(id: 1, userId: 1, name: "Artyom", balance: 1000, currency: "$", createdAt: dateExample, updatedAt: dateExample),
            category: Category(id: 1, name: "categorytest", emoji: "✅", isIncome: .income),
            amount: 30.0,
            transactionDate: dateExample,
            comment: "",
            createdAt: dateExample,
            updatedAt: dateExample
          )
        
        XCTAssertEqual(resultTransaction, correctTransaction)
    }

}
