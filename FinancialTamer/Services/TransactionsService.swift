//
//  TransactionsService.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 10.06.2025.
//

import Foundation

final class TransactionsService {
    
    static let shared = TransactionsService()
    
    let networkClient = NetworkClient()
    
    private(set) var transactions: [Transaction] = []
    private(set) var categories: [Category] = []
    private(set) var account: Account?
    
    private init() {}
    
    // MARK: - Methods
    
    func loadTransactions(direction: Direction) async throws {
        if categories.isEmpty {
            self.categories = try await CategoriesService.shared.categories()
        }

        if account == nil {
            self.account = try await BankAccountsService.shared.account()
        }
        
        guard let account = self.account else {
            print("TransactionsService: Аккаунт не загружен")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let url = Constants.Urls.transactionsByAccountAndPeriod(account.id)
        
        do {
            let response: [TransactionResponse] = try await networkClient.request(
                url: url,
                responseType: [TransactionResponse].self
            )
            self.transactions = response.map { $0.toDomain(account: account) }
        } catch {
            print("❌ TransactionsService: Ошибка загрузки транзакций: \(error.localizedDescription)")
            print("🔻 Подробности: \(error)")
        }
    }
    
    func transactions(direction: Direction, for period: Range<Date> = Date.distantPast..<Date.distantFuture) async throws -> [Transaction] {
        transactions.filter {
            period.contains($0.transactionDate) && $0.category.isIncome == direction
        }
    }
    
    func createTransaction(transaction: Transaction) async throws {
        let request = TransactionRequest(
            accountId: transaction.account.id,
            categoryId: transaction.category.id,
            amount: transaction.amount,
            transactionDate: ISO8601DateFormatter().string(from: transaction.transactionDate),
            comment: transaction.comment
        )
        
        do {
            let response: TransactionResponse = try await networkClient.request(
                url: Constants.Urls.transactions,
                method: "POST",
                body: request,
                responseType: TransactionResponse.self
            )
            guard let account = account else { return }
            self.transactions = [response.toDomain(account: account)]
            print("✅ Успешно создана транзакция")
        } catch {
            print("❌ TransactionsService: Ошибка создания транзакции: \(error)")
            throw error
        }
    }
    
    func editTransaction(transaction: Transaction) async throws {
        guard let index = transactions.firstIndex(where: { $0.id == transaction.id }) else { return }
        transactions[index] = transaction
    }
    
    func deleteTransaction(transaction: Transaction) async throws {
        transactions.removeAll { $0.id == transaction.id }
    }
}
