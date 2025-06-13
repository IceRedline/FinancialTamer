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
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                VStack{
                    Text("Транзакций: \(transactions.count)")
                    
                    
                    List(transactions, id: \.id) { transaction in
                        Text("Сумма: \(transaction.amount.description)")
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Расходы сегодня")
            .task {
                await loadTransactions()
            }
            .toolbar {
                Button("", systemImage: "clock") {
                    print("About tapped!")
                }
                .tint(.purple)
            }
        }
    }
    
    private func loadTransactions() async {
        do {
            let list = try await TransactionsService.shared.transactions()
            transactions = list
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
}

#Preview {
    TransactionsListView(direction: .income)
}
