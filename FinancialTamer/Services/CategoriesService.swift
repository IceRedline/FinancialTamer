//
//  CategoriesService.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 10.06.2025.
//

import Foundation

final class CategoriesService {
    
    static let shared = CategoriesService()
    
    private init() {}
    
    let categories: [Category] = [
        Category(id: 1, name: "Аренда квартиры", emoji: "🏠", isIncome: .outcome),
        Category(id: 2, name: "Одежда", emoji: "👔", isIncome: .outcome),
        Category(id: 3, name: "На собачку", emoji: "🐕", isIncome: .outcome),
        Category(id: 4, name: "Ремонт квартиры", emoji: "🔨", isIncome: .outcome),
        Category(id: 5, name: "Продукты", emoji: "🍬", isIncome: .outcome),
        Category(id: 6, name: "Спортзал", emoji: "🏋️", isIncome: .outcome),
        Category(id: 7, name: "Медицина", emoji: "💊", isIncome: .outcome),
        Category(id: 8, name: "Аптека", emoji: "💜", isIncome: .outcome),
        Category(id: 9, name: "Машина", emoji: "🚗", isIncome: .outcome),
        Category(id: 10, name: "Рестораны", emoji: "🍽️", isIncome: .outcome),
        Category(id: 11, name: "Зарплата", emoji: "💵", isIncome: .income),
        Category(id: 12, name: "Подработка", emoji: "💰", isIncome: .income)
    ]
    
    func categories() async throws -> [Category] {
        categories
    }
    
    func specifiedCategories(direction: Direction) async throws -> [Category] {
        categories.filter({ $0.isIncome == direction })
    }
}
