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
    
    var isIncomeBool: Bool {
        self == .income
    }
    
    init?(isIncomeBool: Bool) {
        self = isIncomeBool ? .income : .outcome
    }
}

struct Category: Equatable {
    let id: Int
    let name: String
    let emoji: Character
    let isIncome: Direction
}

extension Category {
    
    var jsonObject: [String: Any] {
        ["id": id,
         "name": name,
         "emoji": String(emoji),
         "isIncome": isIncome.isIncomeBool
        ]
    }
    
    static func parse(jsonObject: Any) -> Category? {
        guard let dict = jsonObject as? [String: Any],
              let id = dict["id"] as? Int,
              let name = dict["name"] as? String,
              let emojiStr = dict["emoji"] as? String,
              let emoji = emojiStr.first,
              let isIncomeBool = dict["isIncome"] as? Bool,
              let isIncome = Direction(isIncomeBool: isIncomeBool)
        else {
            return nil
        }
        
        return Category(id: id, name: name, emoji: emoji, isIncome: isIncome)
    }
}
