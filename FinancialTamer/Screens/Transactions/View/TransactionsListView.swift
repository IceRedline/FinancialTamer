//
//  ContentView.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 08.06.2025.
//

import SwiftUI

struct TransactionsListView: View {
    
    let direction: Direction
    
    @ObservedObject var model = TransactionsListModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .bottomTrailing) {
                Color.background.ignoresSafeArea(edges: .top)
                transactionsList
                addButton
            }
            .navigationTitle(direction == .outcome ? "Расходы сегодня" : "Доходы сегодня")
            .toolbar {
                NavigationLink(destination: HistoryView(direction: self.direction)) {
                    Image(systemName: "clock")
                        .tint(.purpleAccent)
                }
            }
            .task {
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
                
                ForEach(model.groupedByCategory, id: \.category.id) { item in
                    NavigationLink {
                        
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
