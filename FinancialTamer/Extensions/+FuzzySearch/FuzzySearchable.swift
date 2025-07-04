//
//  FuzzySearchable.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 04.07.2025.
//

import Foundation

protocol FuzzySearchable {
    var searchableString: String { get }

    func fuzzyMatch(query: String) -> FuzzySearchMatchResult
}

extension FuzzySearchable {
    func fuzzyMatch(query: String) -> FuzzySearchMatchResult {
        let searchString = query.lowercased()
        let compareString = searchableString.lowercased()
        
        var totalScore = 0
        var matchedParts = [NSRange]()
        var currentMatchedPart = NSRange(location: 0, length: 0)
        
        var searchIndex = searchString.startIndex
        var compareIndex = compareString.startIndex
        
        while searchIndex < searchString.endIndex && compareIndex < compareString.endIndex {
            if searchString[searchIndex] == compareString[compareIndex] {
                if currentMatchedPart.length == 0 {
                    currentMatchedPart.location = compareString.distance(from: compareString.startIndex, to: compareIndex)
                }
                currentMatchedPart.length += 1
                totalScore += 1
                searchIndex = searchString.index(after: searchIndex)
            } else {
                if currentMatchedPart.length > 0 {
                    matchedParts.append(currentMatchedPart)
                    currentMatchedPart = NSRange(location: 0, length: 0)
                }
            }
            compareIndex = compareString.index(after: compareIndex)
        }
        
        if currentMatchedPart.length > 0 {
            matchedParts.append(currentMatchedPart)
        }
        
        let matchedLength = matchedParts.reduce(0) { $0 + $1.length }
        let isFullMatch = matchedLength == searchString.count
        
        return FuzzySearchMatchResult(
            weight: isFullMatch ? totalScore * 100 : totalScore,
            matchedParts: isFullMatch ? matchedParts : []
        )
    }
}
