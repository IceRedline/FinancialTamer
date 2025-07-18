//
//  CategoryResponse.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 15.07.2025.
//

import Foundation

struct CategoryResponse: Decodable {
    let id: Int
    let name: String
    let emoji: String
    let isIncome: Bool
    
    func toDomain() -> Category {
        let direction = Direction(isIncomeBool: isIncome)
        let emojiCharacter = emoji.first ?? "❓"
        return Category(id: id, name: name, emoji: emojiCharacter, isIncome: direction ?? .outcome)
    }
}
