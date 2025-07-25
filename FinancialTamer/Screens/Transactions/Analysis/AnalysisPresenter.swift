//
//  AnalysisPresenter.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 04.07.2025.
//

import UIKit

final class AnalysisPresenter: NSObject {
    
    weak var viewController: AnalysisViewController?
    let transactionsService = TransactionsService.shared
    
    var firstDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    var secondDate = Date.now
    var lastDateChanged: DateChanged = .first
    var chosenPeriodSum: Decimal = 0
    var currency: Currency = .RUB
    
    private(set) var transactions: [Transaction] = []
    
    let direction: Direction
    
    init(direction: Direction) {
        self.direction = direction
    }
    
    // MARK: - Methods
    
    func viewDidLoad() {
        Task { [weak self] in
            guard let self else { return }
            
            await self.loadTransactions(direction: self.direction)
            
            if let account = try? await AccountsService.shared.account() {
                self.currency = Currency.from(ticker: account.currency) ?? .RUB
                
                await MainActor.run {
                    self.viewController?.tableView.reloadData()
                }
            }
        }
    }
    
    func attach(viewController: AnalysisViewController) {
        self.viewController = viewController
    }
    
    func loadTransactions(direction: Direction) async {
        let calendar = Calendar.current

        var firstDay = calendar.startOfDay(for: firstDate)
        var secondDay = calendar.endOfDay(for: secondDate)!

        switch lastDateChanged {
        case .first:
            if firstDay > secondDay {
                secondDate = calendar.endOfDay(for: firstDate)!
                secondDay = secondDate
            }
        case .second:
            if secondDay < firstDay {
                firstDate = calendar.startOfDay(for: secondDate)
                firstDay = firstDate
            }
        }

        let range = firstDay..<secondDay

        do {
            let list = try await transactionsService.transactions(direction: direction, for: range)

            let sum = list.reduce(Decimal(0)) { $0 + $1.amount }

            await MainActor.run {
                self.transactions = list
                self.chosenPeriodSum = sum
                self.viewController?.tableView.reloadData()
            }

        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
    
    func sort(by parameter: SortType) {
        switch parameter {
        case .date:
            transactions.sort(by: { $0.transactionDate > $1.transactionDate })
        case .sum:
            transactions.sort(by: { $0.amount > $1.amount })
        }
        
        viewController?.tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension AnalysisPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 3 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 4
        case 1: return 1
        case 2: return transactions.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellNames.configCell, for: indexPath) as! ConfigCell
            if indexPath.row == 0 {
                cell.configure(title: "Период: начало", date: firstDate, change: .first) { newDate, change in
                    self.firstDate = newDate
                    self.lastDateChanged = change
                    Task {
                        await self.loadTransactions(direction: self.direction)
                    }
                }
            } else if indexPath.row == 1 {
                cell.configure(title: "Период: конец", date: secondDate, change: .second) { newDate, change in
                    self.secondDate = newDate
                    self.lastDateChanged = change
                    Task {
                        await self.loadTransactions(direction: self.direction)
                    }
                }
            } else if indexPath.row == 2 {
                cell.configureAsButtonCell { [weak self] sortType in
                    self?.sort(by: sortType)
                }
            } else {
                cell.configure(title: "Сумма", value: chosenPeriodSum.formattedCurrency(currency: currency.symbol))
            }
            return cell
            
        } else if indexPath.section == 1 {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
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
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellNames.transactionCell, for: indexPath) as! TransactionCell
            let transaction = transactions[indexPath.row]
            var percentage = (transaction.amount / chosenPeriodSum * 100)
            var roundedPercentage = Decimal()
            NSDecimalRound(&roundedPercentage, &percentage, 0, .plain)
            cell.configure(with: transaction, percentage: roundedPercentage, currency: currency)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension AnalysisPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewController?.presentEdit(for: transactions[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
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
