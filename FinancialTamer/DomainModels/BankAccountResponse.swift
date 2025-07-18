//
//  BankAccountResponse.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 15.07.2025.
//

import Foundation

struct AccountResponse: Decodable {
    let id: Int
    let userId: Int?
    let name: String
    let balance: Decimal
    let currency: String
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, userId, name, balance, currency, createdAt, updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        userId = try container.decodeIfPresent(Int.self, forKey: .userId)
        name = try container.decode(String.self, forKey: .name)
        currency = try container.decode(String.self, forKey: .currency)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)

        if let balanceStr = try? container.decode(String.self, forKey: .balance),
           let decimalValue = Decimal(string: balanceStr) {
            balance = decimalValue
        } else if let balanceDouble = try? container.decode(Double.self, forKey: .balance) {
            balance = Decimal(balanceDouble)
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .balance,
                in: container,
                debugDescription: "Invalid balance format"
            )
        }
    }

    func toDomain() -> Account {
        return Account(
            id: id,
            userId: userId,
            name: name,
            balance: balance,
            currency: currency,
            createdAt: ISO8601DateFormatter().date(from: createdAt ?? ""),
            updatedAt: ISO8601DateFormatter().date(from: updatedAt ?? "")
        )
    }
}
