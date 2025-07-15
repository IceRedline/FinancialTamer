//
//  TransactionResponse.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 15.07.2025.
//

import Foundation

struct TransactionResponse: Decodable {
    let id: Int
    let amount: Decimal
    let transactionDate: String
    let comment: String?
    let category: CategoryResponse
    let accountId: Int
    let createdAt: String
    let updatedAt: String
    
    func toDomain(account: BankAccount) -> Transaction {
        Transaction(
            id: id,
            account: account,
            category: category.toDomain(),
            amount: amount,
            transactionDate: ISO8601DateFormatter().date(from: transactionDate) ?? Date(),
            comment: comment,
            createdAt: ISO8601DateFormatter().date(from: createdAt) ?? Date(),
            updatedAt: ISO8601DateFormatter().date(from: updatedAt) ?? Date()
        )
    }
}
