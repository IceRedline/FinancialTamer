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
    let account: BankAccountResponse
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, amount, transactionDate, comment, category, account, createdAt, updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        transactionDate = try container.decode(String.self, forKey: .transactionDate)
        comment = try container.decodeIfPresent(String.self, forKey: .comment)
        category = try container.decode(CategoryResponse.self, forKey: .category)
        account = try container.decode(BankAccountResponse.self, forKey: .account)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)

        // Парсим amount
        if let amountStr = try? container.decode(String.self, forKey: .amount),
           let decimalValue = Decimal(string: amountStr) {
            amount = decimalValue
        } else if let amountDouble = try? container.decode(Double.self, forKey: .amount) {
            amount = Decimal(amountDouble)
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .amount,
                in: container,
                debugDescription: "Invalid amount format"
            )
        }
    }

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
