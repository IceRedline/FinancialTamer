//
//  ContentView.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 08.06.2025.
//

import SwiftUI

struct CategoriesView: View {
    
    @ObservedObject var model = CategoriesModel()
    
    @State var textToSearch: String = ""
    
    var searchResults: [Category] {
        if textToSearch.isEmpty {
            return model.categories
        } else {
            return model.categories.fuzzySearch(query: textToSearch) .map {
                $0.item
            }
        }
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .bottomTrailing) {
                Color.background.ignoresSafeArea(edges: .top)
                
                List {
                    Section("Статьи") {
                        ForEach(searchResults, id: \.id) { category in
                            HStack {
                                EmojiCircle(emoji: category.emoji)
                                Text(category.name)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                
            }
            .navigationTitle("Мои статьи")
            .task {
                await model.loadCategories()
            }
        }
        .searchable(text: $textToSearch)
    }
}

#Preview {
    MainTabView()
}
