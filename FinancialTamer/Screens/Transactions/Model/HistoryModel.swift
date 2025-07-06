//
//  TransactionsListModel.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 22.06.2025.
//

import Foundation

enum DateChanged {
    case first
    case second
}

enum SortType {
    case date
    case sum
}

class HistoryModel: ObservableObject {
    
    let transactionsService = TransactionsService.shared
    
    @Published var firstDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    @Published var secondDate = Date.now
    @Published var lastDateChanged: DateChanged = .first
    
    @Published var transactions: [Transaction] = []
    @Published var chosenPeriodSum: Decimal = 0
    
    
    func loadTransactions(direction: Direction) async {
        
        let calendar = Calendar.current
        
        var firstDay = calendar.startOfDay(for: firstDate)
        var secondDay = calendar.endOfDay(for: secondDate)!
        
        switch lastDateChanged {
        case .first:
            if firstDay > secondDay {
                secondDate = calendar.endOfDay(for: firstDate)!
                secondDay = secondDate
            }
        case .second:
            if secondDay < firstDay {
                firstDate = calendar.startOfDay(for: secondDate)
                firstDay = firstDate
            }
        }
        
        let range = firstDay..<secondDay
        
        do {
            let list = try await transactionsService.transactions(direction: direction, for: range)

            var sum: Decimal = 0
            list.forEach { transaction in
                sum += transaction.amount
            }

            DispatchQueue.main.async {
                self.transactions = list
                self.chosenPeriodSum = sum
            }
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
    
    func sort(by parameter: SortType) {
        switch parameter {
        case .date:
            transactions.sort(by: { $0.transactionDate > $1.transactionDate })
        case .sum:
            transactions.sort(by: { $0.amount > $1.amount })
        }
    }
    
    func loadAndPrepareDataForView(direction: Direction) async {
        await transactionsService.loadMockData()
        await loadTransactions(direction: direction)
    }
}
