//
//  Currency.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 15.07.2025.
//

import Foundation

enum Currency: String, CaseIterable, Identifiable {
    case RUB = "RUB"
    case USD = "USD"
    case EUR = "EUR"

    var id: String { rawValue }
    
    var symbol: String {
        switch self {
        case .RUB: return "₽"
        case .USD: return "$"
        case .EUR: return "€"
        }
    }

    static func from(ticker: String?) -> Currency? {
        guard let ticker = ticker else { return nil }
        return Currency(rawValue: ticker)
    }
}
