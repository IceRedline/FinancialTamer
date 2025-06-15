//
//  HistoryView.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 15.06.2025.
//

import SwiftUI

struct HistoryView: View {
    
    @State private var firstDate = Date.now
    @State private var secondDate = Date.now
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .bottomTrailing) {
                Color.background.ignoresSafeArea(edges: .top)
                
                List {
                    Section {
                        HStack {
                            Text("Начало")
                            Spacer()
                            DatePicker("", selection: $firstDate, in: ...Date.now, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .background(Color.accentLight)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        HStack {
                            Text("Конец")
                            Spacer()
                            DatePicker("", selection: $secondDate, in: ...Date.now, displayedComponents: .date)
                                .labelsHidden()
                                .background(Color.accentLight)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        HStack {
                            Text("Сумма")
                            Spacer()
                            Text("125 868 ₽")
                        }
                        
                    }
                    
                    
                    Section(header: Text("Операции")) {
                        /*
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
                         }*/
                        
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
            
        }
    }
}

#Preview {
    MainTabView()
}
