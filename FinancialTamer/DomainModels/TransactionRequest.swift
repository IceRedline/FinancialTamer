//
//  TransactionRequest.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 15.07.2025.
//

import Foundation

struct TransactionRequest: Encodable {
    let accountId: Int
    let categoryId: Int
    let amount: Decimal
    let transactionDate: String
    let comment: String?
}
