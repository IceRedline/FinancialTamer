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
          account: BankAccount(id: 1, userId: 1, name: "Artyom", balance: 1000, currency: "$", createdAt: dateExample, updatedAt: dateExample),
          category: Category(id: 1, name: "categorytest", emoji: "✅", isIncome: .income),
          amount: 30,
          transactionDate: dateExample,
          comment: "",
          createdAt: dateExample,
          updatedAt: dateExample
        )

        let resultJsonDictionary = testTransaction.jsonObject

        let correctJSONDict: [String : Any] = ["updatedAt": "2001-01-01T00:00:00Z", "comment": "", "createdAt": "2001-01-01T00:00:00Z", "category": ["emoji": "✅", "isIncomeBool": true, "name": "categorytest", "id": 1], "transactionDate": "2001-01-01T00:00:00Z", "id": 1, "amount": 30.0, "account": ["id": 1, "createdAt": "2001-01-01T00:00:00Z", "currency": "$", "updatedAt": "2001-01-01T00:00:00Z", "userId": 1, "name": "Artyom", "balance": "1000"]]
        
        let resultString = try jsonString(from: resultJsonDictionary)
        let correctString = try jsonString(from: correctJSONDict)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    func testParse() throws {
        
        let dateExample = Date(timeIntervalSinceReferenceDate: 0)

        let testJSONDict: [String : Any] = ["updatedAt": "2001-01-01T00:00:00Z", "comment": "", "createdAt": "2001-01-01T00:00:00Z", "category": ["emoji": "✅", "isIncomeBool": true, "name": "categorytest", "id": 1], "transactionDate": "2001-01-01T00:00:00Z", "id": 1, "amount": 30.0, "account": ["id": 1, "createdAt": "2001-01-01T00:00:00Z", "currency": "$", "updatedAt": "2001-01-01T00:00:00Z", "userId": 1, "name": "Artyom", "balance": "1000"]]

        let resultTransaction = Transaction.parse(jsonObject: testJSONDict)
        
        let correctTransaction = Transaction(
            id: 1,
            account: BankAccount(id: 1, userId: 1, name: "Artyom", balance: 1000, currency: "$", createdAt: dateExample, updatedAt: dateExample),
            category: Category(id: 1, name: "categorytest", emoji: "✅", isIncome: .income),
            amount: 30,
            transactionDate: dateExample,
            comment: "",
            createdAt: dateExample,
            updatedAt: dateExample
          )
        
        XCTAssertEqual(resultTransaction, correctTransaction)
    }

}
