//
//  AnalysisPresenter.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 04.07.2025.
//

import UIKit

final class AnalysisPresenter: NSObject {
    
    weak var viewController: AnalysisViewController?
    
    var startDate = Date()
    var endDate = Date()
    
    private(set) var transactions: [Transaction] = TransactionsService.shared.transactions
    
    func attach(viewController: AnalysisViewController) {
        self.viewController = viewController
    }
}


extension AnalysisPresenter: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int { 3 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return 1
        case 2: return transactions.count
        default: return 0
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
        case 0: return 50
        case 1: return 120
        case 2: return 60
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 2 ? "Операции" : nil
    }
}
