//
//  NetworkConstants.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 14.07.2025.
//

import Foundation

struct Constants {
    private static let baseUrlPath = "https://shmr-finance.ru/api/v1"
    
    struct Urls {
        // Accounts
        static let accounts = URL(string: "\(baseUrlPath)/accounts")!
        
        static func accountById(_ id: Int) -> URL {
            URL(string: "\(baseUrlPath)/accounts/\(id)")!
        }
        
        static func accountHistory(_ id: Int) -> URL {
            URL(string: "\(baseUrlPath)/accounts/\(id)/history")!
        }
        
        // Categories
        static let categories = URL(string: "\(baseUrlPath)/categories")!
        
        static func categoriesByType(_ isIncome: Bool) -> URL {
            URL(string: "\(baseUrlPath)/categories/type/\(isIncome)")!
        }
        
        // Transactions
        static let transactions = URL(string: "\(baseUrlPath)/transactions")!
        
        static func transactionById(_ id: Int) -> URL {
            URL(string: "\(baseUrlPath)/transactions/\(id)")!
        }
        
        static func transactionsByAccountAndPeriod(_ accountId: Int) -> URL {
            URL(string: "\(baseUrlPath)/transactions/account/\(accountId)/period")!
        }
    }
}
