//
//  BankAccountsService.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 10.06.2025.
//

import Foundation

final class BankAccountsService {
    
    private var accounts: [BankAccount] = [BankAccount(id: 1, userId: 1, name: "Main Account", balance: 1000, currency: "$", createdAt: Date(), updatedAt: Date()),
                                   BankAccount(id: 2, userId: 2, name: "Disabled Account", balance: 0, currency: "₽", createdAt: Date(), updatedAt: Date())]
    
    func account() async throws -> BankAccount {
        guard let account = accounts.first else {
            throw NSError(domain: "BankAccountsService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Нет аккаунта"])
        }
        return account
    }
    
    func updateAccount(account: BankAccount) async throws {
        accounts[0] = account
    }
}
