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
    @Published var errorMessage: String? = nil {
        didSet {
            hasError = errorMessage != nil
        }
    }
    @Published var hasError: Bool = false
    
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
            await MainActor.run(body: {
                print("❌ AccountModel: Ошибка загрузки счёта: \(error.localizedDescription)")
                self.errorMessage = "Ошибка загрузки счёта"
            })
        }
    }
}
