//
//  ContentView.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 08.06.2025.
//

import SwiftUI

struct TransactionsListView: View {
    
    let direction: Direction
    let transactionsService = TransactionsService.shared
    
    @State private var transactions: [Transaction] = []
    @State private var sum: Decimal = 0
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.background.ignoresSafeArea(edges: .top)
                
                List { // List уже реализует ленивую загрузку и переиспользование ячеек
                    Section {
                        HStack {
                            Text("Всего")
                            Spacer()
                            Text("\(sum) ₽")
                        }
                    }
                    
                    
                    Section(header: Text("Операции")) {
                        
                        ForEach(transactions, id: \.id) { transaction in
                            NavigationLink {
                                EditTransactionView(transaction: transaction)
                            } label: {
                                
                                HStack {
                                    if direction == .outcome {
                                        Text("\(transaction.category.emoji)")
                                            .font(.caption)
                                            .frame(width: 24, height: 24)
                                            .background(Color.accentLight)
                                            .clipShape(Circle())
                                    }
                                    
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
                                    
                                    Text("\(transaction.amount) ₽")
                                        .foregroundColor(.primary)
                                }
                                .frame(height: 25)
                                
                            }
                        }
                         
                        
                    }
                }
                .scrollContentBackground(.hidden)
                
                Button(action: {
                    print("Tapped add button")
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(Circle())
                }
                .padding(24)
                
            }
            .navigationTitle(direction == .outcome ? "Расходы сегодня" : "Доходы сегодня")
            .toolbar {
                NavigationLink(destination: HistoryView()) {
                    Image(systemName: "clock")
                        .tint(.purpleAccent)
                }
            }
            .task {
                await transactionsService.loadMockData()
                await loadTransactions()
            }
        }
    }
    
    private func loadTransactions() async {
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let todayRange = startOfDay..<startOfNextDay
        
        do {
            let list = try await transactionsService.transactions(direction: self.direction, for: todayRange)
            transactions = list
            var sum: Decimal = 0
            transactions.forEach { transaction in
                sum += transaction.amount
                self.sum = sum
            }
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
}

#Preview {
    TransactionsListView(direction: .income)
}
