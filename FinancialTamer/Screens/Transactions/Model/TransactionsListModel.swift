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
    @Published private(set) var groupedByCategory: [(category: Category, total: Decimal)] = []
    @Published private(set) var sum: Decimal = 0
    
    func loadTransactions(direction: Direction) async {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let todayRange = startOfDay..<startOfNextDay

        do {
            let list = try await transactionsService.transactions(direction: direction, for: todayRange)
            
            let grouped = Dictionary(grouping: list, by: { $0.category })
            let result = grouped.map { (category, items) in
                (category: category, total: items.reduce(Decimal(0)) { $0 + $1.amount })
            }
            let sortedResult = result.sorted { $0.total > $1.total }
            let totalSum = sortedResult.reduce(0) { $0 + $1.total }
            
            await MainActor.run {
                self.transactions = list
                self.groupedByCategory = sortedResult
                self.sum = totalSum
            }
            
        } catch {
            await MainActor.run {
                print("Ошибка загрузки: \(error)")
            }
        }
    }
}
