//
//  String+levenshteinDistance.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 04.07.2025.
//

import Foundation

extension String {
    func levenshteinDistance(to string: String) -> Int {
        let a = self.lowercased()
        let b = string.lowercased()
        let m = a.count
        let n = b.count
        
        var matrix = [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: m + 1)
        
        for i in 1...m {
            matrix[i][0] = i
        }
        
        for j in 1...n {
            matrix[0][j] = j
        }
        
        for i in 1...m {
            for j in 1...n {
                let cost = a[a.index(a.startIndex, offsetBy: i-1)] == b[b.index(b.startIndex, offsetBy: j-1)] ? 0 : 1
                matrix[i][j] = Swift.min(
                    matrix[i-1][j] + 1,
                    matrix[i][j-1] + 1,
                    matrix[i-1][j-1] + cost
                )
            }
        }
        
        return matrix[m][n]
    }
}
