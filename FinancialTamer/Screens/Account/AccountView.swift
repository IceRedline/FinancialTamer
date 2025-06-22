//
//  ContentView.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 08.06.2025.
//

import SwiftUI

enum AccountViewMode {
    case view
    case edit
}

struct AccountView: View {
    
    @ObservedObject var model = AccountModel()
    
    @State private var currentMode: AccountViewMode = .view
    @State private var showingCurrencySheet = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.background.ignoresSafeArea(edges: .top)
                
                List {
                    
                    HStack {
                        Text("💰    Баланс")
                        Spacer()
                        if currentMode == .edit {
                            TextField("Баланс", value: $model.editableBalance, format: .number)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 100, height: 20, alignment: .trailing)
                                .foregroundStyle(Color.gray)
                        } else {
                            Text(model.account?.balance.formattedCurrency(currency: model.currency) ?? "")
                        }
                    }
                    .listRowBackground(currentMode == .view ? Color.accent : Color.white)
                    
                    HStack {
                        Text("Валюта")
                        Spacer()
                        Text("\(model.currency)")
                            .foregroundStyle(currentMode == .view ? Color.black : Color.gray)
                        
                        if currentMode == .edit {
                            Button {
                                showingCurrencySheet = true
                            } label: {
                                HStack {
                                    Image(systemName: "chevron.right")
                                        .imageScale(.small)
                                        .foregroundColor(.gray)
                                }
                            }
                            .confirmationDialog("Валюта", isPresented: $showingCurrencySheet, titleVisibility: .visible) {
                                Button("Российский рубль ₽") {
                                    model.currency = "₽"
                                }
                                
                                Button("Американский доллар $") {
                                    model.currency = "$"
                                }
                                
                                Button("Евро €") {
                                    model.currency = "€"
                                }
                            }
                            .tint(Color.purpleAccent)
                        }
                    }
                    .listRowBackground(currentMode == .view ? Color.accentLight : Color.white)
                    
                }
                .scrollContentBackground(.hidden)
                .scrollDismissesKeyboard(.interactively)
                
            }
            .listRowSpacing(16)
            .navigationTitle("Мой счет")
            .toolbar {
                Button(currentMode == .view ? "Редактировать" : "Сохранить") {
                    if currentMode == .edit {
                        Task {
                            await model.updateBalance()
                        }
                    } else {
                        model.editableBalance = model.account?.balance ?? 0
                    }
                    currentMode = currentMode == .view ? .edit : .view
                }
                .tint(.purpleAccent)
            }
            .task {
                await model.loadAccount()
            }
        }
    }
}

#Preview {
    MainTabView()
}
