//
//  ContentView.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 08.06.2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Image(systemName: "gear")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Настройки в разработке")
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
