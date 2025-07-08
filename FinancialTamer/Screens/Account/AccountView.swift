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
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .bottomTrailing) {
                Color.background.ignoresSafeArea(edges: .top)
                accountList
            }
            .listRowSpacing(16)
            .navigationTitle("Мой счет")
            .toolbar {
                editButton
            }
            .task {
                await model.loadAccount()
            }
        }
    }
    
    // MARK: - Views
    
    private var accountList: some View {
        List {
            
            HStack {
                Text("💰    Баланс")
                Spacer()
                if currentMode == .edit {
                    balanceTextField
                } else {
                    balanceText
                }
            }
            .listRowBackground(currentMode == .view ? Color.accent : Color.white)
            
            HStack {
                Text("Валюта")
                Spacer()
                Text("\(model.currency)")
                    .foregroundStyle(currentMode == .view ? Color.black : Color.gray)
                
                if currentMode == .edit {
                    currencyPopupButton
                }
            }
            .onChange(of: currentMode) { _, newMode in
                if newMode == .edit {
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
    
    private var balanceTextField: some View {
        TextField("Баланс", text: $editableBalanceString)
            .keyboardType(.decimalPad)
            .textFieldStyle(.plain)
            .multilineTextAlignment(.trailing)
            .frame(width: 150, height: 20, alignment: .trailing)
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
    }
    
    private var balanceText: some View {
        Text(model.account?.balance.formattedCurrency(currency: model.currency) ?? "")
            .spoiler(isOn: $spoilerIsOn)
            .onShake {
                spoilerIsOn.toggle()
            }
    }
    
    private var currencyPopupButton: some View {
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
    
    private var editButton: some View {
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
}

#Preview {
    MainTabView()
}
