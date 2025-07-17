//
//  LocalTransaction.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 16.07.2025.
//

import SwiftData
import Foundation

@Model
final class LocalTransaction {
    var id: Int
    var amount: Decimal
    var transactionDate: Date
    var comment: String
    var accountId: Int
    var categoryId: Int
    var isIncome: Bool

    init(from transaction: Transaction) {
        self.id = transaction.id
        self.amount = transaction.amount
        self.transactionDate = transaction.transactionDate
        self.comment = transaction.comment ?? ""
        self.accountId = transaction.account.id
        self.categoryId = transaction.category.id
        self.isIncome = transaction.category.isIncome == .income ? true : false
    }

    func toDomain(account: Account, category: Category) -> Transaction {
        Transaction(
            id: self.id,
            account: account,
            category: category,
            amount: self.amount,
            transactionDate: self.transactionDate,
            comment: self.comment,
            createdAt: self.transactionDate,
            updatedAt: self.transactionDate
        )
    }
}
