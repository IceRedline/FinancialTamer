//
//  CustomDatePicker.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 08.07.2025.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var selection: Date
    var displayedComponents: DatePickerComponents = .date

    var body: some View {
        DatePicker("", selection: $selection, in: ...Date.now, displayedComponents: displayedComponents)
            .datePickerStyle(.compact)
            .labelsHidden()
            .background(Color.accentLight)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
