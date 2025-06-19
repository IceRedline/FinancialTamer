//
//  MainTabView.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 13.06.2025.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        TabView {
            TransactionsListView(direction: .outcome)
                .tabItem {
                    Label("Расходы", image: "expenses")
                }
                .tag(1)
            
            TransactionsListView(direction: .income)
                .tabItem {
                    Label("Доходы", image: "income")
                }
                .tag(1)
            
            AccountView()
                .tabItem {
                    Label("Счёт", image: "account")
                }
                .tag(1)
            
            CategoriesView()
                .tabItem {
                    Label("Статьи", image: "categories")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Настройки", image: "settings")
                }
                .tag(1)
        }
        .tint(.accent)
    }
}

#Preview {
    MainTabView()
}
