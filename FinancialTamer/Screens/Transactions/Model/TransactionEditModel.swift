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
        print("Выбрана категория: \(category.name)")
        transaction.category = category
    }
    
    func amountChanged(amount: Decimal) {
        transaction.amount = amount
        print("Сумма изменена! Новая сумма: \(transaction.amount)")
    }
    
    func editAndSaveTransaction() async {
        try? await transactionsService.editTransaction(transaction: self.transaction)
    }
    
    func deleteTransaction() async {
        try? await transactionsService.deleteTransaction(transaction: self.transaction)
    }
}
