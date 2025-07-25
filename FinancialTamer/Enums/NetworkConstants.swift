//
//  NetworkConstants.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 14.07.2025.
//

import Foundation

struct Constants {
    static let get = "GET"
    static let post = "POST"
    static let put = "PUT"
    static let delete = "DELETE"
    
    static let baseUrl = "https://shmr-finance.ru/api/v1"
    static let bearerToken = "nRld8CbB4zsfUCd0q1y0FVnS"
    
    struct Urls {
        // Accounts
        static let accounts = URL(string: "\(baseUrl)/accounts")!
        
        static func updateAccount(_ id: Int) -> URL {
            URL(string: "\(baseUrl)/accounts/\(id)")!
        }
        
        static func accountHistory(_ id: Int) -> URL {
            URL(string: "\(baseUrl)/accounts/\(id)/history")!
        }
        
        // Categories
        static let categories = URL(string: "\(baseUrl)/categories")!
        
        static func categoriesByType(_ isIncome: Bool) -> URL {
            URL(string: "\(baseUrl)/categories/type/\(isIncome)")!
        }
        
        // Transactions
        static let transactions = URL(string: "\(baseUrl)/transactions")!
        
        static func transactionById( id: Int) -> URL {
            URL(string: "\(baseUrl)/transactions/\(id)")!
        }
        
        static func transactionsByAccountAndPeriod(_ accountId: Int) -> URL {
            URL(string: "\(baseUrl)/transactions/account/\(accountId)/period")!
        }
    }
}
