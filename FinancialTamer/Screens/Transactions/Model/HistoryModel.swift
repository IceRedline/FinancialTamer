//
//  TransactionsListModel.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 22.06.2025.
//

import Foundation

class HistoryModel: ObservableObject {
    
    let transactionsService = TransactionsService.shared
    
    @Published var firstDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    @Published var secondDate = Date.now
    @Published var lastDateChanged: DateChanged = .first
    @Published var transactions: [Transaction] = []
    @Published var chosenPeriodSum: Decimal = 0
    @Published var currency: Currency = .RUB
    @Published var errorMessage: String? = nil {
        didSet {
            hasError = errorMessage != nil
        }
    }
    @Published var hasError: Bool = false
    
    // MARK: - Methods
    
    @MainActor
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
        
        if let account = try? await AccountsService.shared.account() {
            currency = Currency.from(ticker: account.currency) ?? .RUB
        }
        
        do {
            let list = try await transactionsService.transactions(direction: direction, for: range)
            
            var sum: Decimal = 0
            list.forEach { transaction in
                sum += transaction.amount
            }
            
            await MainActor.run(body: {
                self.transactions = list
                self.chosenPeriodSum = sum
                self.currency = currency
            })
        } catch {
            await MainActor.run(body: {
                print("❌ HistoryModel: Ошибка загрузки транзакций: \(error.localizedDescription)")
                self.errorMessage = "Ошибка загрузки транзакций"
            })
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
    
    @MainActor
    func loadAndPrepareDataForView(direction: Direction) async {
        await loadTransactions(direction: direction)
    }
}
