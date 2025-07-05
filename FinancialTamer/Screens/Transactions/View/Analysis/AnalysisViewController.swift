//
//  AnalysisViewController.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 04.07.2025.
//

import UIKit

class AnalysisViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let datePickerTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var startDate = Date()
    private var endDate = Date()
    
    private let transactions: [Transaction] = TransactionsService.shared.transactions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Анализ"
        view.backgroundColor = .systemGroupedBackground
        
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
        
        datePickerTableView.dataSource = self
        datePickerTableView.delegate = self
        datePickerTableView.register(DatePickerCell.self, forCellReuseIdentifier: "DatePickerCell")
        datePickerTableView.register(TransactionCell.self, forCellReuseIdentifier: "OperationCell")
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int { 3 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: 3
        case 1: 1
        case 2: transactions.count
        default: 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath) as! DatePickerCell
            if indexPath.row == 0 {
                cell.configure(title: "Период: начало", date: startDate) { [weak self] newDate in
                    self?.startDate = newDate
                }
            } else if indexPath.row == 1 {
                cell.configure(title: "Период: конец", date: endDate) { [weak self] newDate in
                    self?.endDate = newDate
                }
            } else {
                cell.configure(title: "Сумма", value: "125 868 ₽")
            }
            return cell
            
        } else if indexPath.section == 1 {
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            let label = UILabel()
            label.text = "Здесь когда-то будет график ._."
            label.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            ])
            return cell
            
        } else {
            let transaction = transactions[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "OperationCell", for: indexPath) as! TransactionCell
            cell.configure(with: transaction)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: 50
        case 1: 120
        case 2: 60
        default: 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 2 ? "Операции" : nil
    }
}

#Preview(traits: .defaultLayout, body: {
    AnalysisViewController()
})
