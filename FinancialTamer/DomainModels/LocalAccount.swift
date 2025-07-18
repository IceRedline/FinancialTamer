//
//  LocalAccount.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 18.07.2025.
//

import SwiftData
import Foundation

@Model
final class LocalAccount {
    var id: Int
    var userId: Int?
    var name: String
    var balance: Decimal
    var currency: String
    var createdAt: Date?
    var updatedAt: Date?

    init(id: Int, userId: Int?, name: String, balance: Decimal, currency: String, createdAt: Date?, updatedAt: Date?) {
        self.id = id
        self.userId = userId
        self.name = name
        self.balance = balance
        self.currency = currency
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    func toDomain() -> Account {
        Account(
            id: self.id,
            userId: self.userId,
            name: self.name,
            balance: self.balance,
            currency: self.currency,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt
        )
    }
}
