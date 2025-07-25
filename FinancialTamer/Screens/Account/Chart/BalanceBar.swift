//
//  BalanceBar.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 25.07.2025.
//

import Foundation

struct BalanceBar: Identifiable {
    let id = UUID()
    let date: Date
    let balance: Decimal

    var doubleBalance: Double {
        NSDecimalNumber(decimal: balance).doubleValue
    }
}
