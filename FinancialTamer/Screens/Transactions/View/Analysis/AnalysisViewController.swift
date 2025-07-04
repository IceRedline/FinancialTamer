//
//  AnalysisViewController.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 04.07.2025.
//

import UIKit

class AnalysisViewController: UIViewController {

    private let presenter = AnalysisPresenter()

    private let datePickerTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var startDate = Date()
    private var endDate = Date()
    
    private let transactions: [Transaction] = TransactionsService.shared.transactions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Анализ"
        view.backgroundColor = .systemGroupedBackground
        
        presenter.attach(viewController: self)
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(datePickerTableView)
        datePickerTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePickerTableView.topAnchor.constraint(equalTo: view.topAnchor),
            datePickerTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            datePickerTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            datePickerTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        datePickerTableView.dataSource = presenter
        datePickerTableView.delegate = presenter
        datePickerTableView.register(DatePickerCell.self, forCellReuseIdentifier: "DatePickerCell")
        datePickerTableView.register(TransactionCell.self, forCellReuseIdentifier: "OperationCell")
    }
}

#Preview(traits: .defaultLayout, body: {
    AnalysisViewController()
})
