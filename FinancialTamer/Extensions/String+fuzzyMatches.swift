//
//  +String.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 01.07.2025.
//

import Foundation

extension String {
    func fuzzyMatches(_ searchTerm: String) -> Bool {
        self.lowercased().contains(searchTerm.lowercased().replacingOccurrences(of: " ", with: ""))
    }
}
