//
//  AccountHistoryResponse.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 25.07.2025.
//

import Foundation

// MARK: - Корневая структура
struct AccountHistoryResponse: Decodable {
    let accountId: Int
    let accountName: String
    let currency: String
    let currentBalance: String
    let history: [AccountHistory]
}

// MARK: - История изменений
struct AccountHistory: Decodable {
    let id: Int
    let accountId: Int
    let changeType: String
    let previousState: AccountState?
    let newState: AccountState
    let changeTimestamp: String
    let createdAt: String
}

// MARK: - Состояние счёта
struct AccountState: Decodable {
    let id: Int
    let name: String
    let balance: String
    let currency: String
}
