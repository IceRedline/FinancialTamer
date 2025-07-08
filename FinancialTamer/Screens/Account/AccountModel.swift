//
//  AccountModel.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 22.06.2025.
//

import Foundation

class AccountModel: ObservableObject {
    
    let accountService = BankAccountsService.shared
    
    @Published var currentMode: AccountViewMode = .view
    @Published var account: BankAccount?
    @Published var editableBalance: Decimal = 0
    @Published var currency: String = "₽"
    
    // MARK: - Methods
    
    @MainActor
    func loadAccount() async {
        do {
            let loadedAccount = try await accountService.account()
            self.account = loadedAccount
            guard let balance = account?.balance else { return }
            self.editableBalance = balance
            print("аккаунт загружен!")
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
    
    @MainActor
    func updateBalance() async {
        print("Баланс обновлен!")
        do {
            try await accountService.updateBalance(newBalance: editableBalance)
            await loadAccount()
        } catch {
            print("")
        }
    }
}
