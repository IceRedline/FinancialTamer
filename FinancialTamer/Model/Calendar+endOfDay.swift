//
//  Calendar+EndOfDay.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 17.06.2025.
//

import Foundation

extension Calendar {
    func endOfDay(for date: Date) -> Date? {
        guard let startOfNextDay = self.date(byAdding: .day, value: 1, to: startOfDay(for: date)) else {
            return nil
        }
        return self.date(byAdding: .second, value: -1, to: startOfNextDay)
    }
}
