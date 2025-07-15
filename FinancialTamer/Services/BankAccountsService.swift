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
    
    var accounts: [BankAccount] = []
    
    private init() {}
    
    // MARK: - Methods
    
    func account() async throws -> BankAccount {
        if accounts.isEmpty {
            try await loadAccounts()
        }
        return accounts.first!
    }

    private func loadAccounts() async throws {
        do {
            let response: [BankAccountResponse] = try await networkClient.request(
                url: Constants.Urls.accounts,
                responseType: [BankAccountResponse].self
            )
            self.accounts = response.map { $0.toDomain() }
            print(accounts)
        } catch {
            print("❌ BankAccountsService: Ошибка загрузки аккаунтов: \(error)")
            throw error
        }
    }
    

    func updateAccount(account: BankAccount) async throws {
        let request = UpdateAccountRequest(
            name: account.name,
            balance: account.balance,
            currency: account.currency
        )
        
        do {
            let response: BankAccountResponse = try await networkClient.request(
                url: Constants.Urls.updateAccount(account.id),
                method: "PUT",
                body: request,
                responseType: BankAccountResponse.self
            )
            
            self.accounts = [response.toDomain()]
            print("✅ Успешно обновлен счет")
        } catch {
            print("❌ BankAccountsService: Ошибка обновления аккаунта: \(error)")
            throw error
        }
    }
        
    
    func updateBalance(newBalance: Decimal, newCurrency: String) async throws {
        let previousAccount = accounts[0]
        let newAccount = BankAccount(
            id: previousAccount.id,
            userId: previousAccount.userId,
            name: previousAccount.name,
            balance: newBalance,
            currency: newCurrency,
            createdAt: previousAccount.createdAt,
            updatedAt: previousAccount.updatedAt
        )
        try? await updateAccount(account: newAccount)
    }
}
