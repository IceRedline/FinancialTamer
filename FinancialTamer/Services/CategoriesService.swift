//
//  CategoriesService.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 10.06.2025.
//

import Foundation

final class CategoriesService {
    
    static let shared = CategoriesService()
    
    let networkClient = NetworkClient()
    let url = URL(string: "\(Constants.baseUrl)/categories")!
    
    private(set) var categories: [Category] = []
    
    private init() {}
    
    func categories() async throws -> [Category] {
        if categories.isEmpty {
            try await loadCategories()
        }
        return categories
    }

    private func loadCategories() async throws {
        print("🌐 начали загрузку категорий")
        do {
            let response: [CategoryResponse] = try await networkClient.request(
                url: url,
                responseType: [CategoryResponse].self
            )
            self.categories = response.map { $0.toDomain() }
            print("✅ Загружено категорий: \(categories.count)")
        } catch {
            print("❌ Ошибка загрузки категорий: \(error)")
            throw error
        }
    }
    
    func specifiedCategories(direction: Direction) async throws -> [Category] {
        categories.filter({ $0.isIncome == direction })
    }
}
