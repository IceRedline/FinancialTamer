//
//  TransactionsListModelProtocol.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 22.06.2025.
//

import Foundation

protocol TransactionsListModelProtocol: ObservableObject {
    
    var transactionsService: TransactionsService { get }
    
    var transactions: [Transaction] { get }
    var groupedByCategory: [(category: Category, total: Decimal)] { get }
    var sum: Decimal { get }
    
    func loadTransactions(direction: Direction) async
}
