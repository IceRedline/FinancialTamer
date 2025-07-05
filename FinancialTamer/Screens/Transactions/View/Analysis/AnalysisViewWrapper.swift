//
//  AnalysisViewWrapper.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 04.07.2025.
//

import SwiftUI

struct AnalysisViewWrapper: UIViewControllerRepresentable {
    let direction: Direction
    
    init(direction: Direction) {
        self.direction = direction
    }
    
    func makeUIViewController(context: Context) -> AnalysisViewController {
        return AnalysisViewController(direction: direction)
    }

    func updateUIViewController(_ uiViewController: AnalysisViewController, context: Context) {}
}
