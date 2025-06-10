//
//  CategoriesService.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 10.06.2025.
//

import Foundation

final class CategoriesService {
    
    private var categories: [Category] = [Category(id: 1, name: "testCategory1", emoji: "👍🏼", direction: Direction.income),
                                          Category(id: 2, name: "testCategory2", emoji: "❤️", direction: Direction.outcome),
                                          Category(id: 3, name: "testCategory3", emoji: "✅", direction: Direction.income)]
    
    func categories() async throws -> [Category] {
        categories
    }
    
    func specifiedCategories(direction: Direction) async throws -> [Category] {
        categories.filter({ $0.direction == direction })
    }
}
