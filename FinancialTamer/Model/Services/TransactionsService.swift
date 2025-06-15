//
//  TransactionsService.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 10.06.2025.
//

import Foundation

final class TransactionsService {
    
    static let shared = TransactionsService()
    
    private(set) var transactions: [Transaction] = []
    private(set) var categories: [Category] = []
    private(set) var account: BankAccount?
    
    private init() {}
    
    func loadMockData() async {
        self.categories = try! await CategoriesService().categories()
        self.account = try! await BankAccountsService().account()
        
        guard let account = self.account else {
            print("❌ Аккаунт не загружен")
            return
        }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        self.transactions = [
            Transaction(
                id: 1,
                account: account,
                category: categories[0],
                amount: 100000,
                transactionDate: formatter.date(from: "2025-06-15T12:09:00.000Z")!,
                comment: "",
                createdAt: formatter.date(from: "2025-06-14T12:00:00.000Z")!,
                updatedAt: formatter.date(from: "2025-06-14T12:00:00.000Z")!
            ),
            Transaction(
                id: 2,
                account: account,
                category: categories[1],
                amount: 100000,
                transactionDate: formatter.date(from: "2025-06-15T12:00:00.000Z")!,
                comment: "",
                createdAt: formatter.date(from: "2025-06-14T12:00:00.000Z")!,
                updatedAt: formatter.date(from: "2025-06-14T12:00:00.000Z")!
            ),
            Transaction(
                id: 3,
                account: account,
                category: categories[2],
                amount: 100000,
                transactionDate: formatter.date(
                    from: "2025-06-15T12:00:00.000Z"
                )!,
                comment: "Джек",
                createdAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!,
                updatedAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!
            ),
            Transaction(
                id: 4,
                account: account,
                category: categories[3],
                amount: 100000,
                transactionDate: formatter.date(
                    from: "2025-06-15T12:00:00.000Z"
                )!,
                comment: "Энни",
                createdAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!,
                updatedAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!
            ),
            Transaction(
                id: 5,
                account: account,
                category: categories[4],
                amount: 100000,
                transactionDate: formatter.date(
                    from: "2025-06-15T12:00:00.000Z"
                )!,
                comment: "",
                createdAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!,
                updatedAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!
            ),
            Transaction(
                id: 6,
                account: account,
                category: categories[5],
                amount: 100000,
                transactionDate: formatter.date(
                    from: "2025-06-15T12:00:00.000Z"
                )!,
                comment: "",
                createdAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!,
                updatedAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!
            ),
            Transaction(
                id: 7,
                account: account,
                category: categories[6],
                amount: 100000,
                transactionDate: formatter.date(
                    from: "2025-06-15T12:00:00.000Z"
                )!,
                comment: "",
                createdAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!,
                updatedAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!
            ),
            Transaction(
                id: 8,
                account: account,
                category: categories[7],
                amount: 100000,
                transactionDate: formatter.date(
                    from: "2025-06-15T12:00:00.000Z"
                )!,
                comment: "",
                createdAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!,
                updatedAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!
            ),
            Transaction(
                id: 9,
                account: account,
                category: categories[8],
                amount: 100000,
                transactionDate: formatter.date(
                    from: "2025-06-15T12:00:00.000Z"
                )!,
                comment: "",
                createdAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!,
                updatedAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!
            ),
            Transaction(
                id: 10,
                account: account,
                category: categories[9],
                amount: 100000,
                transactionDate: formatter.date(
                    from: "2025-06-15T12:00:00.000Z"
                )!,
                comment: "",
                createdAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!,
                updatedAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!
            ),
            Transaction(
                id: 11,
                account: account,
                category: categories[10],
                amount: 100000,
                transactionDate: formatter.date(
                    from: "2025-06-15T12:00:00.000Z"
                )!,
                comment: "",
                createdAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!,
                updatedAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!
            ),
            Transaction(
                id: 12,
                account: account,
                category: categories[11],
                amount: 100000,
                transactionDate: formatter.date(
                    from: "2025-06-15T12:00:00.000Z"
                )!,
                comment: "",
                createdAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!,
                updatedAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!
            ),
            Transaction(
                id: 13,
                account: account,
                category: categories[12],
                amount: 100000,
                transactionDate: formatter.date(
                    from: "2025-06-15T12:00:00.000Z"
                )!,
                comment: "",
                createdAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!,
                updatedAt: formatter.date(
                    from: "2025-06-14T12:00:00.000Z"
                )!
            )
        ]
    }
    
    func transactions(direction: Direction, for period: Range<Date> = Date.distantPast..<Date.distantFuture) async throws -> [Transaction] {
        transactions.filter {
            period.contains($0.transactionDate) && $0.category.isIncome == direction
        }
    }
    
    func createTransaction(transaction: Transaction) async throws {
        guard !transactions.contains(where: { $0.id == transaction.id }) else { return }
        transactions.append(transaction)
    }
    
    func editTransaction(transaction: Transaction) async throws {
        guard let index = transactions.firstIndex(where: { $0.id == transaction.id }) else { return }
        transactions[index] = transaction
    }
    
    func deleteTransaction(transaction: Transaction) async throws {
        transactions.removeAll { $0.id == transaction.id }
    }
}
