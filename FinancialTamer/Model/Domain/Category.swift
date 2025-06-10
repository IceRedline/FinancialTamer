//
//  Category.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 08.06.2025.
//

import Foundation

enum Direction {
    case income
    case outcome
}

struct Category {
    let id: Int
    let name: String
    let emoji: Character
    let direction: Direction
}
