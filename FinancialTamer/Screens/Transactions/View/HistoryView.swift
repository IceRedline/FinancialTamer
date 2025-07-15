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
    @State private var selectedTransaction: Transaction? = nil
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.background.ignoresSafeArea(.all)
                transactionsList
            }
            .navigationTitle("Мои операции")
            .toolbar {
                NavigationLink(destination: AnalysisViewWrapper(direction: direction).edgesIgnoringSafeArea([.top])) {
                    Image(systemName: "document")
                        .tint(.purpleAccent)
                }
            }
            .alert("Ошибка", isPresented: $model.hasError, actions: {
                Button("Повторить") {
                    Task {
                        await model.loadAndPrepareDataForView(direction: direction)
                    }
                }
            }, message: {
                Text(model.errorMessage ?? "Неизвестная ошибка")
            })
        }
        .fullScreenCover(item: $selectedTransaction) { transaction in
            TransactionEditView(
                model: TransactionEditModel(transaction: transaction),
                direction: direction, currentMode: .edit
            )
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
        .onChange(of: selectedTransaction) { _, newValue in
            if newValue == nil {
                Task {
                    await model.loadTransactions(direction: direction)
                }
            }
        }
        .onAppear {
            Task {
                await model.loadAndPrepareDataForView(direction: direction)
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
                    Button {
                        selectedTransaction = transaction
                    } label: {
                        HStack {
                            EmojiCircle(emoji: transaction.category.emoji)
                            VStack(alignment: .leading) {
                                Text(transaction.category.name)
                                    .foregroundStyle(Color.primary)
                                if let comment = transaction.comment, !comment.isEmpty {
                                    Text(comment)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                            Text(transaction.amount.formattedCurrency())
                                .foregroundStyle(Color.primary)
                            ChevronImage()
                        }
                    }
                    .foregroundStyle(.black)
                }
            }
        }
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
