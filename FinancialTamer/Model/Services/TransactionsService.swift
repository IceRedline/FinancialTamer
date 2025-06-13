//
//  TransactionsService.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 10.06.2025.
//

import Foundation

class TransactionsService {
    
    static let shared = TransactionsService()
    private init() {}
    
    let cache = TransactionsFileCache()
    
    func transactions(for period: Range<Date> = Date.distantPast..<Date.distantFuture) async throws -> [Transaction] {
        cache.loadTransactions().filter({ period.contains($0.createdAt) })
    }
    
    func createTransaction(transaction: Transaction) async throws {
        cache.addTransaction(transaction: transaction)
    }
    
    func editTransaction(transaction: Transaction) async throws {
        cache.updateTransaction(transaction)
    }
    
    func deleteTransaction(transaction: Transaction) async throws {
        cache.removeTransaction(id: transaction.id)
    }
}
