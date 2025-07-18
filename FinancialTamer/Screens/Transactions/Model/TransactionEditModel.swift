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
    
    @Published var transaction: Transaction
    @Published var categories: [Category] = []
    @Published var currency: Currency = .RUB
    
    init(transaction: Transaction) {
        self.transaction = transaction
    }
    
    @MainActor
    func loadCategories(for direction: Direction) async {
        do {
            let loadedCategories = try await categoriesService.categories()
            self.categories = loadedCategories.filter({$0.isIncome == direction})
            print("Категории загружены!")
            
            await MainActor.run(body: {
                self.currency = currency
            })
            
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
    
    func checkTransaction() -> Bool {
        if transaction.category != Category.empty &&
            transaction.amount != 0 &&
            transaction.comment != nil {
            return true
        }
        return false
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
            print("TransactionEditModel: Ошибка загрузки транзакций: \(error)")
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
            print("TransactionEditModel: Ошибка загрузки транзакций: \(error)")
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
            print("TransactionEditModel: Ошибка загрузки транзакций: \(error)")
            return false
        }
    }
}
