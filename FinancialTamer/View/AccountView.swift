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
    
    let accountService = BankAccountsService.shared
    
    @State private var currentMode: AccountViewMode = .view
    @State private var account: BankAccount?
    @State private var editableBalance: Decimal = 0
    @State private var currency: String = "₽"
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
                            TextField("Баланс", value: $editableBalance, format: .number)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 100, height: 20, alignment: .trailing)
                                .foregroundStyle(Color.gray)
                        } else {
                            Text(account?.balance.formattedCurrency(currency: currency) ?? "")
                        }
                    }
                    .listRowBackground(currentMode == .view ? Color.accent : Color.white)
                    
                    HStack {
                        Text("Валюта")
                        Spacer()
                        Text("\(currency)")
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
                                    currency = "₽"
                                }
                                
                                Button("Американский доллар $") {
                                    currency = "$"
                                }
                                
                                Button("Евро €") {
                                    currency = "€"
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
                            await updateBalance()
                        }
                    } else {
                        editableBalance = account?.balance ?? 0
                    }
                    currentMode = currentMode == .view ? .edit : .view
                }
                .tint(.purpleAccent)
            }
            .task {
                await loadAccount()
            }
        }
    }
    
    private func loadAccount() async {
        do {
            let loadedAccount = try await accountService.account()
            self.account = loadedAccount
            guard let balance = account?.balance else { return }
            self.editableBalance = balance
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
    
    private func updateBalance() async {
        do {
            try await accountService.updateBalance(newBalance: editableBalance)
            await loadAccount()
        } catch {
            print("")
        }
    }
}

#Preview {
    MainTabView()
}
