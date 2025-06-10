//
//  TransactionsFileCache.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 09.06.2025.
//

import Foundation

final class TransactionsFileCache {
    
    private(set) var transactions: [Transaction] = []
    private let fileURL: URL
    
    init(filename: String = "transactions.json") {
        self.fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)
        self.transactions = loadTransactions()
    }
    
    func addTransaction(transaction: Transaction) {
        guard !transactions.contains(where: { $0.id == transaction.id }) else { return }
        transactions.append(transaction)
        saveTransactions()
    }
    
    func removeTransaction(id: Int) {
        transactions.removeAll(where: { $0.id == id })
        saveTransactions()
    }
    
    func saveTransactions() {
        let jsonArray = transactions.map({ $0.jsonObject })
        guard JSONSerialization.isValidJSONObject(jsonArray),
              let data = try? JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
        else {
            print("TransactionsFileCache: ошибка сериализации")
            return
        }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("TransactionsFileCache: не удалось записать в файл")
        }
    }
    
    func loadTransactions() -> [Transaction] {
        guard let data = try? Data(contentsOf: fileURL),
              let json = try? JSONSerialization.jsonObject(with: data),
              let array = json as? [[String : Any]]
        else { return [] }
        
        return array.compactMap { Transaction.parse(jsonObject: $0) }
    }
    
}
