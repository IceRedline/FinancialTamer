//
//  TransactionsStorage.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 16.07.2025.
//

import Foundation

protocol TransactionsStorageProtocol {
    func fetchAll() throws -> [LocalTransaction]
    func add(_ transaction: LocalTransaction) throws
    func update(_ transaction: LocalTransaction) throws
    func delete(withId id: Int) throws
}
