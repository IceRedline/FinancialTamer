//
//  BalanceChartView.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 25.07.2025.
//

import SwiftUI
import Charts

struct BalanceChartView: View {
    let bars: [BalanceBar]
    
    var body: some View {
        if bars.isEmpty {
            VStack {
                Text("Нет данных для графика")
                    .foregroundColor(.red)
                Text("Количество полученных записей: \(bars.count)")
            }
        } else {
            Chart {
                ForEach(bars) { bar in
                    BarMark(
                        x: .value("Дата", bar.date, unit: .day),
                        y: .value("Баланс", bar.doubleBalance)
                    )
                    .foregroundStyle(bar.doubleBalance >= 0 ? .accent : .redAccent)
                    .cornerRadius(3)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 9)) { value in
                    AxisValueLabel(format: .dateTime.day().month(.twoDigits))
                }
            }
            .chartYAxis {
            }
            .frame(height: 220)
        }
    }
}
