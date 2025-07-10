//
//  ContentView.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 08.06.2025.
//

import SwiftUI

struct TransactionsListView: View {
    
    let direction: Direction
    
    @StateObject private var model = TransactionsListModel()
    @State private var selectedTransaction: Transaction? = nil
    @State private var isDataLoaded = false
    @State private var showingEditView = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.background.ignoresSafeArea(.all)
                if isDataLoaded {
                    transactionsList
                } else {
                    ProgressView()
                }
                addButton
            }
            .navigationTitle(direction == .outcome ? "Расходы сегодня" : "Доходы сегодня")
            .toolbar {
                NavigationLink(destination: HistoryView(direction: self.direction)) {
                    Image(systemName: "clock").tint(.purpleAccent)
                }
            }
            .fullScreenCover(isPresented: $showingEditView) {
                TransactionEditView(
                    model: TransactionEditModel(transaction: Transaction.empty),
                    direction: direction,
                    currentMode: .create
                )
            }
            .onChange(of: showingEditView) { _, newValue in
                if newValue == false {
                    Task {
                        await model.loadTransactions(direction: direction)
                    }
                }
            }
            .onAppear {
                let observer = NotificationCenter.default.addObserver(
                    forName: .mockDataLoaded,
                    object: nil,
                    queue: .main
                ) { _ in
                    Task {
                        await model.loadAndPrepareDataForView(direction: direction)
                        DispatchQueue.main.async {
                            isDataLoaded = true
                        }
                    }
                }
                
                Task {
                    if !TransactionsService.shared.transactions.isEmpty {
                        await model.loadAndPrepareDataForView(direction: direction)
                        isDataLoaded = true
                    }
                }
            }
            
        }
        .fullScreenCover(item: $selectedTransaction) { transaction in
            TransactionEditView(
                model: TransactionEditModel(transaction: transaction),
                direction: direction,
                currentMode: .edit
            )
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
                    Text("Всего")
                    Spacer()
                    Text(model.sum.formattedCurrency())
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
                                if let comment = transaction.comment, !comment.isEmpty {
                                    Text(comment).font(.footnote).foregroundColor(.gray)
                                }
                            }
                            Spacer()
                            Text(transaction.amount.formattedCurrency())
                        }
                    }
                    .foregroundStyle(.black)
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
    
    private var addButton: some View {
        Button(action: {
            showingEditView = true
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
}

#Preview {
    MainTabView()
}
