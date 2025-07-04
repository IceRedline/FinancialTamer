//
//  Collection+fuzzySearch.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 04.07.2025.
//

import Foundation

extension Collection where Iterator.Element: FuzzySearchable {
    func fuzzySearch(query: String, threshold: Double = 0.7) -> [(result: Double, item: Iterator.Element)] {
        return compactMap { item in
            let searchString = query.lowercased()
            let targetString = item.searchableString.lowercased()
            
            if targetString == searchString {
                return (result: 1.0, item: item)
            }
            
            if targetString.contains(searchString) {
                return (result: 0.9, item: item)
            }
            
            let distance = Double(targetString.levenshteinDistance(to: searchString))
            let maxLength = Double(Swift.max(targetString.count, searchString.count))
            let similarity = 1.0 - (distance / maxLength)
            
            if similarity >= threshold {
                return (result: similarity, item: item)
            }
            
            return nil
        }.sorted { $0.result > $1.result }
    }
}

