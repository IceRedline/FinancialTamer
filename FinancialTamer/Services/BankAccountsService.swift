//
//  BankAccountsService.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 10.06.2025.
//

import Foundation

final class BankAccountsService {
    
    static let shared = BankAccountsService()
    
    private init() {}
    
    var accounts: [BankAccount] = [
        BankAccount(
            id: 1,
            userId: nil,
            name: "Основной счёт",
            balance: 1000,
            currency: "RUB",
            createdAt: nil,
            updatedAt: nil
        ),
        BankAccount(
            id: 2,
            userId: 2,
            name: "Disabled Account",
            balance: 0,
            currency: "₽",
            createdAt: Date(),
            updatedAt: Date()
        )
    ]
    
    func account() async throws -> BankAccount {
        guard let account = accounts.first else {
            throw NSError(domain: "BankAccountsService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Нет аккаунта"])
        }
        return account
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
