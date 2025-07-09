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
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .bottomTrailing) {
                Color.background.ignoresSafeArea(edges: .top)
                transactionsList
            }
            .navigationTitle("Моя история")
            .toolbar {
                NavigationLink(destination: AnalysisViewWrapper(direction: direction).edgesIgnoringSafeArea([.top])) {
                    Image(systemName: "document")
                        .tint(.purpleAccent)
                }
            }
            .task {
                await model.loadAndPrepareDataForView(direction: direction)
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
    
    // MARK: - Views
    
    private var transactionsList: some View {
        List {
            Section {
                HStack {
                    Text("Начало")
                    Spacer()
                    CustomDatePicker(selection: $model.firstDate)
                }
                HStack {
                    Text("Конец")
                    Spacer()
                    CustomDatePicker(selection: $model.secondDate)
                }
                HStack {
                    Spacer()
                    sortMenu
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
                        TransactionEditView(model: TransactionEditModel(transaction: transaction), direction: direction)
                    } label: {
                        
                        HStack {
                            EmojiCircle(emoji: transaction.category.emoji)
                            
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
    
    private var sortMenu: some View {
        Menu("Сортировать") {
            Button("По дате") {
                model.sort(by: .date)
            }
            Button("По сумме") {
                model.sort(by: .sum)
            }
        }
    }
}



#Preview {
    MainTabView()
}
