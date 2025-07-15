//
//  TransactionsListModel.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 22.06.2025.
//

import Foundation

class TransactionsListModel: ObservableObject {
    
    var transactionsService = TransactionsService.shared
    
    @Published private(set) var transactions: [Transaction] = []
    @Published private(set) var sum: Decimal = 0
    
    // MARK: - Methods
    
    func loadTransactions(direction: Direction) async {
        print("🔍 Начали загрузку транзакций для направления: \(direction)")
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let todayRange = startOfDay..<startOfNextDay

        do {
            try await transactionsService.loadTransactions(direction: direction, for: todayRange)
            let list = try await transactionsService.transactions(direction: direction, for: todayRange)
            let totalSum = list.reduce(Decimal(0)) { $0 + $1.amount }
            
            await MainActor.run(body: {
                self.transactions = list
                self.sum = totalSum
            })
        } catch {
            print("TransactionsListModel: Ошибка загрузки транзакций: \(error)")
        }
    }
    
    func loadAndPrepareDataForView(direction: Direction) async {
        await loadTransactions(direction: direction)
    }
}
