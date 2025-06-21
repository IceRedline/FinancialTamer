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
    @State private var groupedByCategory: [(category: Category, total: Decimal)] = []
    @State private var sum: Decimal = 0
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.background.ignoresSafeArea(edges: .top)
                
                List { // List в SwiftUI уже реализует ленивую загрузку и переиспользование ячеек
                    Section {
                        HStack {
                            Text("Всего")
                            Spacer()
                            Text(sum.formattedCurrency())
                        }
                    }
                    
                    
                    Section(header: Text("Операции")) {
                        
                        ForEach(groupedByCategory, id: \.category.id) { item in
                            NavigationLink {
                                //EditTransactionView(category: item.category)
                            } label: {
                                
                                HStack {
                                    if direction == .outcome {
                                        Text("\(item.category.emoji)")
                                            .font(.caption)
                                            .frame(width: 24, height: 24)
                                            .background(Color.accentLight)
                                            .clipShape(Circle())
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.category.name)
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(item.total.formattedCurrency())
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
                NavigationLink(destination: HistoryView(direction: self.direction)) {
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
    
    // MARK: - Methods
    
    private func loadTransactions() async {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let todayRange = startOfDay..<startOfNextDay

        do {
            let list = try await transactionsService.transactions(direction: self.direction, for: todayRange)
            transactions = list
            
            let grouped = Dictionary(grouping: list, by: { $0.category })
            let result = grouped.map { (category, items) in
                (category: category, total: items.reduce(Decimal(0)) { $0 + $1.amount })
            }
            groupedByCategory = result.sorted { $0.total > $1.total }
            
            sum = groupedByCategory.reduce(0) { $0 + $1.total }
            
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
}

#Preview {
    MainTabView()
}
