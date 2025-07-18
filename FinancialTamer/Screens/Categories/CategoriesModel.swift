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
    @Published var errorMessage: String? = nil {
        didSet {
            hasError = errorMessage != nil
        }
    }
    @Published var hasError: Bool = false
    
    @MainActor
    func loadCategories() async {
        do {
            let loadedCategories = try await categoriesService.categories()
            self.categories = loadedCategories
            print("Категории загружены!")
        } catch {
            await MainActor.run(body: {
                print("❌ CategoriesModel: Ошибка загрузки категорий: \(error.localizedDescription)")
                self.errorMessage = "Ошибка загрузки категорий"
            })
        }
    }
}
