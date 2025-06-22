//
//  HistoryView.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 15.06.2025.
//

import SwiftUI

struct HistoryView: View {
    
    let direction: Direction
    
    @ObservedObject var model = HistoryModel()
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .bottomTrailing) {
                Color.background.ignoresSafeArea(edges: .top)
                
                List {
                    Section {
                        HStack {
                            Text("Начало")
                            Spacer()
                            DatePicker("", selection: $model.firstDate, in: ...Date.now, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .background(Color.accentLight)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        HStack {
                            Text("Конец")
                            Spacer()
                            DatePicker("", selection: $model.secondDate, in: ...Date.now, displayedComponents: .date)
                                .labelsHidden()
                                .background(Color.accentLight)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        HStack {
                            Spacer()
                            Menu("Сортировать") {
                                Button("По дате") {
                                    model.sort(by: .date)
                                }
                                Button("По сумме") {
                                    model.sort(by: .sum)
                                }
                            }
                            Spacer()
                        }
                        HStack {
                            Text("Сумма")
                            Spacer()
                            Text(model.chosenPeriodSum.formattedCurrency())
                        }
                    }
                    
                    
                    Section(header: Text("Операции")) {
                        
                        ForEach(model.transactions, id: \.id) { transaction in
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
                                    
                                    Text(transaction.amount.formattedCurrency())
                                        .foregroundColor(.primary)
                                }
                                
                            }
                            .frame(height: 40)
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
                await model.transactionsService.loadMockData()
                await model.loadTransactions(direction: direction)
            }
            .onChange(of: model.firstDate) {
                Task {
                    model.lastDateChanged = .first
                    await model.loadTransactions(direction: direction)
                }
            }
            .onChange(of: model.secondDate) {
                Task {
                    model.lastDateChanged = .second
                    await model.loadTransactions(direction: direction)
                }
            }
            .onChange(of: model.chosenPeriodSum) {
                Task { await model.loadTransactions(direction: direction) }
            }
            
        }
    }
    
    // MARK: - Methods

    
}

#Preview {
    MainTabView()
}
