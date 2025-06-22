//
//  Decimal+formattedCurrency.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 18.06.2025.
//

import Foundation

extension Decimal {
    func formattedCurrency(currency: String = "₽") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "      // Разделитель тысяч
        formatter.maximumFractionDigits = 0    // Без копеек
        formatter.locale = Locale(identifier: "ru_RU")
        
        if let result = formatter.string(from: self as NSNumber) {
            return "\(result) \(currency)"
        } else {
            return "\(self.description) \(currency)"
        }
    }
}
