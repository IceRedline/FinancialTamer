//
//  TransactionEditModel.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 09.07.2025.
//

import Foundation

class TransactionEditModel: ObservableObject {
    
    var transactionsService = TransactionsService.shared
    let categoriesService = CategoriesService.shared
    
    @Published var editableBalance: Decimal = 0
    @Published var transaction: Transaction
    @Published var categories: [Category] = []
    
    init(transaction: Transaction) {
        self.transaction = transaction
    }
    
    @MainActor
    func loadCategories(for direction: Direction) async {
        do {
            let loadedCategories = try await categoriesService.categories()
            self.categories = loadedCategories.filter({$0.isIncome == direction})
            print("Категории загружены!")
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
    
    func categoryChanged(category: Category) {
        transaction.category = category
    }
    
    func amountChanged(amount: Decimal) {
        transaction.amount = amount
    }
    
    @MainActor
    func editAndSaveTransaction() async -> Bool {
        do {
            try await transactionsService.editTransaction(transaction: self.transaction)
            print("Транзакция сохранена успешно")
            return true
        } catch {
            print("Ошибка сохранения транзакции: $error)")
            return false
        }
    }
    
    @MainActor
    func addAndSaveTransaction() async -> Bool {
        do {
            try await transactionsService.createTransaction(transaction: self.transaction)
            print("Транзакция создана успешно")
            return true
        } catch {
            print("Ошибка создания транзакции: $error)")
            return false
        }
    }
    
    @MainActor
    func deleteTransaction() async -> Bool {
        do {
            try await transactionsService.deleteTransaction(transaction: self.transaction)
            print("Транзакция удалена успешно")
            return true
        } catch {
            print("Ошибка удаления транзакции: $error)")
            return false
        }
    }
}
