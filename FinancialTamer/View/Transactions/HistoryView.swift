//
//  HistoryView.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 15.06.2025.
//

import SwiftUI

enum DateChanged {
    case first
    case second
}

enum SortType {
    case date
    case sum
}

struct HistoryView: View {
    
    let transactionsService = TransactionsService.shared
    let direction: Direction
    @State var lastDateChanged: DateChanged = .first
    
    @State private var firstDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    @State private var secondDate = Date.now
    
    @State private var transactions: [Transaction] = []
    @State private var chosenPeriodSum: Decimal = 0
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .bottomTrailing) {
                Color.background.ignoresSafeArea(edges: .top)
                
                List { // List в SwiftUI уже реализует ленивую загрузку и переиспользование ячеек
                    Section {
                        HStack {
                            Text("Начало")
                            Spacer()
                            DatePicker("", selection: $firstDate, in: ...Date.now, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .background(Color.accentLight)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        HStack {
                            Text("Конец")
                            Spacer()
                            DatePicker("", selection: $secondDate, in: ...Date.now, displayedComponents: .date)
                                .labelsHidden()
                                .background(Color.accentLight)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        HStack {
                            Spacer()
                            Menu("Сортировать") {
                                Button("По дате") {
                                    sort(by: .date)
                                }
                                Button("По сумме") {
                                    sort(by: .sum)
                                }
                            }
                            Spacer()
                        }
                        HStack {
                            Text("Сумма")
                            Spacer()
                            Text(chosenPeriodSum.formattedCurrency)
                        }
                    }
                    
                    
                    Section(header: Text("Операции")) {
                        
                        ForEach(transactions, id: \.id) { transaction in
                            NavigationLink {
                                EditTransactionView(transaction: transaction)
                            } label: {
                                
                                HStack {
                                    
                                    Text("\(transaction.category.emoji)")
                                        .font(.caption)
                                        .frame(width: 24, height: 24)
                                        .background(Color.accentLight)
                                        .clipShape(Circle())
                                    
                                    
                                    VStack(alignment: .leading) {
                                        Text(transaction.category.name)
                                            .lineLimit(1)
                                        
                                        if let comment = transaction.comment, !comment.isEmpty {
                                            Text(comment)
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Text(transaction.amount.formattedCurrency)
                                        .foregroundColor(.primary)
                                }
                                .frame(height: 25)
                                
                            }
                        }
                        
                    }
                }
                .scrollContentBackground(.hidden)
                
            }
            .navigationTitle("Моя история")
            .toolbar {
                Button("", systemImage: "document") {
                    print("")
                }
                .tint(.purpleAccent)
            }
            .task {
                await transactionsService.loadMockData()
                await loadTransactions()
            }
            .onChange(of: firstDate) {
                Task {
                    lastDateChanged = .first
                    await loadTransactions()
                }
            }
            .onChange(of: secondDate) {
                Task {
                    lastDateChanged = .second
                    await loadTransactions()
                }
            }
            .onChange(of: chosenPeriodSum) {
                Task { await loadTransactions() }
            }
            
        }
    }
    
    // MARK: - Methods

    private func loadTransactions() async {
        
        let calendar = Calendar.current
        
        var firstDay = calendar.startOfDay(for: firstDate)
        var secondDay = calendar.endOfDay(for: secondDate)!
        
        // ⭐️ Проверка 1 и 2 даты
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
            let list = try await transactionsService.transactions(direction: self.direction, for: range)
            transactions = list
            var sum: Decimal = 0
            transactions.forEach { transaction in
                sum += transaction.amount
            }
            self.chosenPeriodSum = sum
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
    
    private func sort(by parameter: SortType) {
        switch parameter {
        case .date:
            transactions.sort(by: { $0.transactionDate > $1.transactionDate })
        case .sum:
            transactions.sort(by: { $0.amount > $1.amount })
        }
    }
}

#Preview {
    MainTabView()
}
