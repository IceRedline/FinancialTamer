//
//  CategoriesModel.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 29.06.2025.
//

import Foundation

class CategoriesModel: ObservableObject {
    
    let categoriesService = CategoriesService.shared
    
    @Published var categories: [Category] = []
    
    @MainActor
    func loadCategories() async {
        do {
            let loadedCategories = try await categoriesService.categories()
            self.categories = loadedCategories
            print("Категории загружены!")
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
}
