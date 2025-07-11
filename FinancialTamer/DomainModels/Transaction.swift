//
//  Transaction.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 08.06.2025.
//

import Foundation

struct Transaction: Equatable, Identifiable {
    let id: Int
    var account: BankAccount
    var category: Category
    var amount: Decimal
    var transactionDate: Date
    var comment: String?
    var createdAt: Date
    var updatedAt: Date
}

extension Transaction {
    
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    var jsonObject: Any {
        var dictionary: [String : Any] = [
            "id" : id,
            "account" : account.jsonObject,
            "category" : category.jsonObject,
            "amount": String(format: "%.1f", NSDecimalNumber(decimal: amount).doubleValue),
            "transactionDate" : Self.dateFormatter.string(from: transactionDate),
            "createdAt" : Self.dateFormatter.string(from: createdAt),
            "updatedAt" : Self.dateFormatter.string(from: updatedAt),
        ]
        
        if let comment = comment {
            dictionary["comment"] = comment
        } else {
            dictionary["comment"] = NSNull()
        }
        
        return dictionary
    }
    
    static func parse(jsonObject: Any) -> Transaction? {
        guard let dictionary = jsonObject as? [String : Any],
              let id = dictionary["id"] as? Int,
              let accountDict = dictionary["account"] as? [String: Any],
              let account = BankAccount.parse(jsonObject: accountDict),
              let categoryDict = dictionary["category"] as? [String: Any],
              let category = Category.parse(jsonObject: categoryDict),
              let amountString = dictionary["amount"] as? String,
              let amount = Decimal(string: amountString),
              let transactionDateString = dictionary["transactionDate"] as? String,
              let transactionDate = dateFormatter.date(from: transactionDateString),
              let createdAtString = dictionary["createdAt"] as? String,
              let createdAt = dateFormatter.date(from: createdAtString),
              let updatedAtString = dictionary["updatedAt"] as? String,
              let updatedAt = dateFormatter.date(from: updatedAtString)
        else {
            print("❌ Ошибка парсинга Transaction")
            return nil
        }
        
        let comment = dictionary["comment"] as? String
        
        return Transaction(
            id: id,
            account: account,
            category: category,
            amount: amount,
            transactionDate: transactionDate,
            comment: comment,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Transaction {
    static var empty: Transaction {
        Transaction(
            id: UUID().hashValue,
            account: BankAccountsService.shared.accounts.first!,
            category: Category.empty,
            amount: 0,
            transactionDate: Date(),
            comment: "",
            createdAt: Date(),
            updatedAt: Date()
        )
    }
}
