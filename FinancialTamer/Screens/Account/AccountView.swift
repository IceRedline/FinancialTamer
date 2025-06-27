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
    @State var spoilerIsOn = false
    
    @State var editableBalanceString: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.background.ignoresSafeArea(edges: .top)
                
                List {
                    
                    HStack {
                        Text("💰    Баланс")
                        Spacer()
                        if currentMode == .edit {
                            
                            Button("", systemImage: "document.on.clipboard") {
                                if let pasted = UIPasteboard.general.string {
                                    editableBalanceString = pasted
                                }
                            }
                            .font(.system(size: 14))
                            .foregroundStyle(.purpleAccent)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -20))
                            
                            TextField("Баланс", text: $editableBalanceString)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 70, height: 20, alignment: .trailing)
                                .foregroundStyle(Color.gray)
                                .onChange(of: editableBalanceString) { _, newValue in
                                    let filtered = newValue.filter { "0123456789.-,".contains($0) }
                                    let normalized = filtered.replacingOccurrences(of: ",", with: ".")
                                    let components = normalized.components(separatedBy: ".")
                                    let cleaned = components.count > 1 ? components[0] + "." + components[1] : components[0]
                                    editableBalanceString = cleaned
                                    if let value = Decimal(string: cleaned) {
                                        model.editableBalance = value
                                    }
                                }
                            
                        } else {
                            Text(model.account?.balance.formattedCurrency(currency: model.currency) ?? "")
                                .spoiler(isOn: $spoilerIsOn)
                                .onShake {
                                    print("Опачки скрыли деньги")
                                    spoilerIsOn.toggle()
                                }
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
                    .onChange(of: currentMode) { _, newMode in
                        if newMode == .edit {
                            // Устанавливаем начальное значение как строку
                            editableBalanceString = model.editableBalance.description
                        }
                    }
                    .listRowBackground(currentMode == .view ? Color.accentLight : Color.white)
                    
                }
                .scrollContentBackground(.hidden)
                .scrollDismissesKeyboard(.interactively)
                .refreshable {
                    Task {
                        await model.loadAccount()
                    }
                }
                
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
