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
    @State private var isDataLoaded = false
    
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
                
                ForEach(model.groupedByCategory, id: \.category.id) { item in
                    NavigationLink {
                        //TransactionEditView()
                    } label: {
                        
                        HStack {
                            if direction == .outcome {
                                EmojiCircle(emoji: item.category.emoji)
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
    }
    
    private var addButton: some View {
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
}

#Preview {
    MainTabView()
}
