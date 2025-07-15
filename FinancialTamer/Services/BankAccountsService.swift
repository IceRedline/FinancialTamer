//
//  BankAccountsService.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 10.06.2025.
//

import Foundation

final class BankAccountsService {
    
    static let shared = BankAccountsService()
    
    let networkClient = NetworkClient()
    let url = URL(string: "\(Constants.baseUrl)/accounts")!
    
    var accounts: [BankAccount] = []
    
    private init() {}
    
    // MARK: - Methods
    
    func account() async throws -> BankAccount {
        if accounts.isEmpty {
            try await loadAccounts()
        }
        print("🔑 Первый аккаунт: \(accounts.first?.id ?? -1)")
        return accounts.first!
    }

    private func loadAccounts() async throws {
        print("🌐 начали загрузку аккаунтов")
        do {
            let response: [BankAccountResponse] = try await networkClient.request(url: url, responseType: [BankAccountResponse].self)
            self.accounts = response.map { $0.toDomain() }
            print("✅ Загружено аккаунтов: \(accounts.count)")
        } catch {
            print("❌ Ошибка загрузки аккаунтов: \(error)")
            throw error
        }
    }
    
    
    
    func updateAccount(account: BankAccount) async throws {
        accounts[0] = account
    }
    
    func updateBalance(newBalance: Decimal) async throws {
        let previousAccount = accounts[0]
        let newAccount = BankAccount(
            id: previousAccount.id,
            userId: previousAccount.userId,
            name: previousAccount.name,
            balance: newBalance,
            currency: previousAccount.currency,
            createdAt: previousAccount.createdAt,
            updatedAt: previousAccount.updatedAt
        )
        try? await updateAccount(account: newAccount)
    }
}
