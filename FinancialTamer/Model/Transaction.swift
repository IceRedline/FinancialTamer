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
