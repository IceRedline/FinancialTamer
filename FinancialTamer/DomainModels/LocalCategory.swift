//
//  LocalCategory.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 18.07.2025.
//

import Foundation
import SwiftData

@Model
final class LocalCategory {
    var id: Int
    var name: String
    var emojiString: String  // Храним как строку
    var isIncome: Bool

    var emoji: Character {  // Вычисляемое свойство для доступа
        return emojiString.first ?? "❓"
    }

    init(id: Int, name: String, emoji: Character, isIncome: Bool) {
        self.id = id
        self.name = name
        self.emojiString = String(emoji)
        self.isIncome = isIncome
    }

    func toDomain() -> Category {
        Category(
            id: self.id,
            name: self.name,
            emoji: self.emoji,
            isIncome: self.isIncome ? .income : .outcome
        )
    }
}
