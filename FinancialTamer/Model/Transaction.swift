//
//  Transaction.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 08.06.2025.
//

import Foundation

struct Transaction {
    let id: Int
    let accountId: Int
    let categoryId: Int
    let amount: Decimal
    let transactionDate: Date
    let comment: String?
    let createdAt: Date
    let updatedAt: Date
}

extension Transaction {
    
    var jsonObject: Any {
        var dictionary: [String : Any] = [
            "id" : id,
            "accountId" : accountId,
            "categoryId" : categoryId,
            "amount" : (amount as NSDecimalNumber).doubleValue,
            "transactionDate" : ISO8601DateFormatter().string(from: transactionDate),
            "createdAt" : ISO8601DateFormatter().string(from: createdAt),
            "updatedAt" : ISO8601DateFormatter().string(from: updatedAt),
        ]
        
        if let comment = comment {
            dictionary["comment"] = comment
        } else {
            dictionary["comment"] = NSNull()
        }
        
        return dictionary
    }
    
    static func parse(jsonObject: Any) -> Transaction? {
        guard let dictionary = jsonObject as? [String : Any],
              let id = dictionary["id"] as? Int,
              let accountId = dictionary["accountId"] as? Int,
              let categoryId = dictionary["categoryId"] as? Int,
              let amountDouble = dictionary["amount"] as? Double,
              let transactionDateString = dictionary["transactionDate"] as? String,
              let transactionDate = ISO8601DateFormatter().date(from: transactionDateString),
              let createdAtString = dictionary["createdAt"] as? String,
              let createdAt = ISO8601DateFormatter().date(from: createdAtString),
              let updatedAtString = dictionary["updatedAt"] as? String,
              let updatedAt = ISO8601DateFormatter().date(from: updatedAtString)
        else {
            return nil
        }
        
        let comment = dictionary["comment"] as? String
        
        let transaction = Transaction(
            id: id,
            accountId: accountId,
            categoryId: categoryId,
            amount: Decimal(amountDouble),
            transactionDate: transactionDate,
            comment: comment,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
        
        return transaction
    }
}
