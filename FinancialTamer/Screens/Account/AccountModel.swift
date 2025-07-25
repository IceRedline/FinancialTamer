//
//  AccountModel.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 22.06.2025.
//

import Foundation

struct DailyBalance: Identifiable {
    let id = UUID()
    let date: Date
    let balance: Decimal
}

class AccountModel: ObservableObject {
    
    let accountService = AccountsService.shared
    
    @Published var currentMode: AccountViewMode = .view
    @Published var account: Account?
    @Published var editableBalance: Decimal = 0
    @Published var currency: Currency = .RUB
    @Published var history: [AccountHistory] = []
    @Published var chartData: [DailyBalance] = []
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
            guard
                let balance = account?.balance,
                let currency = Currency.from(ticker: account?.currency)
            else { return }
            self.editableBalance = balance
            self.currency = currency
            print("✅ AccountModel: Аккаунт загружен. Баланс: \(balance)")
            await loadHistory()
        } catch {
            print("❌ AccountModel: Ошибка загрузки: \(error)")
        }
    }
    
    @MainActor
    func updateBalance() async {
        print("Баланс обновлен!")
        do {
            try await accountService.updateBalance(newBalance: editableBalance, newCurrency: currency.rawValue)
            await loadAccount()
        } catch {
            await MainActor.run(body: {
                print("❌ AccountModel: Ошибка загрузки счёта: \(error.localizedDescription)")
                self.errorMessage = "Ошибка загрузки счёта"
            })
        }
    }
    
    @MainActor
    func loadHistory() async {
        guard let accountId = account?.id else {
            print("❌ Account ID is nil")
            return
        }

        do {
            let response = try await accountService.accountHistory(accountId: accountId)
            print("✅ История получена. Количество записей:", response.history.count)
            
            self.history = response.history

            let calendar = Calendar.current
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            // Сортируем историю по дате (от старых к новым)
            let sortedHistory = history.compactMap { item -> (AccountHistory, Date)? in
                guard let date = formatter.date(from: item.changeTimestamp) else {
                    print("⚠️ Не удалось разобрать дату:", item.changeTimestamp)
                    return nil
                }
                return (item, date)
            }.sorted { $0.1 < $1.1 }

            // Формируем 30 последних дней (от старых к новым)
            let last30Days = (0..<30).reversed().map { dayOffset in
                calendar.startOfDay(for: calendar.date(byAdding: .day, value: -dayOffset, to: Date())!)
            }

            var dayBalances: [DailyBalance] = []
            
            // Если история полностью отсутствует
            guard let firstHistoryDate = sortedHistory.first?.1 else {
                print("История полностью отсутствует, заполняем нулями")
                dayBalances = last30Days.map { DailyBalance(date: $0, balance: 0) }
                self.chartData = dayBalances
                return
            }

            // Начальный баланс (0 до первого изменения)
            var currentBalance: Decimal = 0
            
            var historyIndex = 0
            for day in last30Days {
                let dayEnd = calendar.date(byAdding: .day, value: 1, to: day)!
                
                // Если день раньше первого изменения - оставляем 0
                guard day >= calendar.startOfDay(for: firstHistoryDate) else {
                    dayBalances.append(DailyBalance(date: day, balance: 0))
                    continue
                }
                
                // Применяем все изменения, которые были до конца этого дня
                while historyIndex < sortedHistory.count {
                    let (item, date) = sortedHistory[historyIndex]
                    guard date < dayEnd else { break }
                    
                    if let newBalance = Decimal(string: item.newState.balance) {
                        currentBalance = newBalance
                    }
                    historyIndex += 1
                }
                
                dayBalances.append(DailyBalance(date: day, balance: currentBalance))
            }

            print("Сформированные данные для графика (первые 5):")
            dayBalances.prefix(5).forEach { print($0.date, $0.balance) }

            self.chartData = dayBalances
            print("Данные графика обновлены. Количество точек:", chartData.count)

        } catch {
            print("❌ Ошибка загрузки истории:", error.localizedDescription)
            self.errorMessage = "Ошибка загрузки истории"
        }
    }
}
