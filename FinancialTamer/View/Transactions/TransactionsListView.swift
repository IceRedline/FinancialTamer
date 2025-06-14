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
            ZStack {
                Color.background.ignoresSafeArea()
                
                List {
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
            }
            .navigationTitle(direction == .outcome ? "Расходы сегодня" : "Доходы сегодня")
            .toolbar {
                Button("", systemImage: "clock") {
                    print("About tapped!")
                }
                .tint(.purple)
            }
            .task {
                await loadTransactions()
            }
        }
    }
    
    private func loadTransactions() async {
        do {
            let list = try await TransactionsService.shared.transactions(direction: self.direction)
            transactions = list
            transactions.forEach { transaction in
                sum += transaction.amount
            }
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
}

#Preview {
    TransactionsListView(direction: .income)
}
