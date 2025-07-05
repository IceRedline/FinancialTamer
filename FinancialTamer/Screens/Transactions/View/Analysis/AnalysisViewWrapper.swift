//
//  AnalysisViewWrapper.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 04.07.2025.
//

import SwiftUI

struct AnalysisViewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AnalysisViewController {
        return AnalysisViewController()
    }

    func updateUIViewController(_ uiViewController: AnalysisViewController, context: Context) {}
}
