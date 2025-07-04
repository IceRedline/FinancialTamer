//
//  String+Normalize.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 04.07.2025.
//

import Foundation

// an extension for Strings to normalise words

extension String {
    func normalise() -> [FuzzySearchCharacter] {
        return self.lowercased().map { char in
        guard let data = String(char).data(using: .ascii, allowLossyConversion: true), let normalisedCharacter = String(data: data, encoding: .ascii) else {
            return FuzzySearchCharacter(content: String(char), normalisedContent: String(char))
            }

        return FuzzySearchCharacter(content: String(char), normalisedContent: normalisedCharacter)
        }
    }
}
