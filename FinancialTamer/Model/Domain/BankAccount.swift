//
//  BankAccount.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 08.06.2025.
//

import Foundation

struct BankAccount: Equatable {
    let id: Int
    let userId: Int?
    let name: String
    let balance: Decimal
    let currency: String
    let createdAt: Date?
    let updatedAt: Date?
}

extension BankAccount {
    
    var jsonObject: Any {
        var dictionary: [String : Any] = [
            "id" : id,
            "name" : name,
            "balance": String(describing: balance),
            "currency" : currency
        ]
        
        if let userId = userId {
            dictionary["userId"] = userId
        }
        if let createdAt = createdAt {
            dictionary["createdAt"] = ISO8601DateFormatter().string(from: createdAt)
        }
        if let updatedAt = updatedAt {
            dictionary["updatedAt"] = ISO8601DateFormatter().string(from: updatedAt)
        }
        
        return dictionary
    }
    
    static func parse(jsonObject: Any) -> BankAccount? {
        guard let dict = jsonObject as? [String: Any],
              let id = dict["id"] as? Int,
              let name = dict["name"] as? String,
              let balanceStr = dict["balance"] as? String,
              let balance = Decimal(string: balanceStr),
              let currency = dict["currency"] as? String
        else {
            return nil
        }

        let userId = dict["userId"] as? Int

        var createdAt: Date? = nil
        if let createdStr = dict["createdAt"] as? String {
            createdAt = ISO8601DateFormatter().date(from: createdStr)
        }

        var updatedAt: Date? = nil
        if let updatedStr = dict["updatedAt"] as? String {
            updatedAt = ISO8601DateFormatter().date(from: updatedStr)
        }

        return BankAccount(
            id: id,
            userId: userId,
            name: name,
            balance: balance,
            currency: currency,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
