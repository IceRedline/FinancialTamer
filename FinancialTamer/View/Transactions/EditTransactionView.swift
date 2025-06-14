//
//  EditTransactionView.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 14.06.2025.
//

import SwiftUI

struct EditTransactionView: View {
    
    let transactionsService = TransactionsService.shared
    
    let transaction: Transaction
    
    var body: some View {
        Text("\(transaction.category.name ?? "no comment")")
    }
}
