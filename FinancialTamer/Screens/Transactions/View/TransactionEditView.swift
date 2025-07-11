//
//  TransationEditView.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 08.07.2025.
//

import SwiftUI

struct TransactionEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var model: TransactionEditModel
    @State private var currentMode: TransactionEditMode
    @State var editableBalanceString: String
    @State private var showAlert = false
    
    let direction: Direction
    
    init(model: TransactionEditModel, direction: Direction, currentMode: TransactionEditMode) {
        self.model = model
        self._editableBalanceString = State(initialValue: model.transaction.amount.formattedCurrency())
        self.direction = direction
        self.currentMode = currentMode
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.background.ignoresSafeArea(.all)
                editingList
            }
            .navigationTitle(direction == .income ? "Мои Доходы" : "Мои Расходы")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отменить") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .tint(.purpleAccent)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(currentMode == .edit ? "Сохранить" : "Создать") {
                        if model.checkTransaction() {
                            Task {
                                await saveAndDismiss()
                            }
                        } else {
                            showAlert = true
                        }
                    }
                    .tint(.purpleAccent)
                }
            }
            .task {
                await model.loadCategories(for: direction)
            }
            .alert("Пожалуйста, заполните все поля", isPresented: $showAlert) {
                Button("ОК", role: .cancel) { }
            }
        }
    }
    
    private var editingList: some View {
        List {
            Section {
                categoryMenu
                
                HStack {
                    Text("Сумма")
                    Spacer()
                    sumTextField
                }
                HStack {
                    Text("Дата")
                    Spacer()
                    CustomDatePicker(selection: $model.transaction.transactionDate)
                }
                HStack {
                    Text("Время")
                    Spacer()
                    CustomDatePicker(selection: $model.transaction.transactionDate, displayedComponents: .hourAndMinute)
                }
                TextField("Комментарий (необязательно)", text: Binding(
                    get: { model.transaction.comment ?? "" },
                    set: { model.transaction.comment = $0.isEmpty ? nil : $0 }
                ))
            }
            
            if currentMode == .edit {
                Section {
                    Button("Удалить расход") {
                        Task {
                            await delete()
                        }
                    }
                    .tint(.red)
                }
            }
        }
    }
    
    private var categoryMenu: some View {
        Menu {
            ForEach(model.categories.filter { $0.isIncome == direction }, id: \.id) { category in
                Button(category.name) {
                    model.categoryChanged(category: category)
                }
            }
        } label: {
            HStack {
                Text("Статья")
                    .foregroundStyle(.black)
                Spacer()
                Text(model.transaction.category.name)
                    .foregroundStyle(.gray)
                Image(systemName: "chevron.down")
                    .imageScale(.small)
                    .foregroundColor(.gray)
            }
            .contentShape(Rectangle())
        }
    }
    
    private var sumTextField: some View {
        TextField("Сумма", text: $editableBalanceString)
            .keyboardType(.decimalPad)
            .textFieldStyle(.plain)
            .multilineTextAlignment(.trailing)
            .frame(width: 150, height: 20, alignment: .trailing)
            .foregroundStyle(Color.gray)
            .onChange(of: editableBalanceString) { _, newValue in
                let locale = Locale.current
                let decimalSeparator = locale.decimalSeparator ?? "."
                let allowedChars = "0123456789" + decimalSeparator
                let filtered = newValue.filter { allowedChars.contains($0) }
                let parts = filtered.components(separatedBy: decimalSeparator)
                var cleaned = parts.prefix(2).joined(separator: decimalSeparator)
                editableBalanceString = cleaned
                let normalized = cleaned.replacingOccurrences(of: decimalSeparator, with: ".")
                if let value = Decimal(string: normalized) {
                    model.amountChanged(amount: value)
                }
            }
    }
    
    private func saveAndDismiss() async {
        if currentMode == .edit {
            await model.editAndSaveTransaction()
        } else {
            await model.addAndSaveTransaction()
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func delete() async {
        await model.deleteTransaction()
        self.presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    MainTabView()
}
