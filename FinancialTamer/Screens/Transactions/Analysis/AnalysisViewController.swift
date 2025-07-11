//
//  AnalysisViewController.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 04.07.2025.
//

import UIKit
import SwiftUI

enum TableViewCellNames {
    static let configCell = "ConfigCell"
    static let transactionCell = "TransactionCell"
}

class AnalysisViewController: UIViewController {
    
    private var presenter: AnalysisPresenter?
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    let direction: Direction
    
    init(direction: Direction) {
        self.direction = direction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = AnalysisPresenter(direction: direction)
        
        view.backgroundColor = .background
        
        presenter?.attach(viewController: self)
        setupTableView()
        presenter?.viewDidLoad()
        
        Task {
            await presenter?.loadTransactions(direction: direction)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTransactionUpdate),
            name: .transactionDidUpdate,
            object: nil
        )
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent?.navigationItem.title = "Анализ"
        
        self.parent?.navigationController?.navigationBar.prefersLargeTitles = true
        self.parent?.navigationItem.largeTitleDisplayMode = .always
        self.parent?.navigationController?.navigationBar.backgroundColor = .background
    }
    
    // MARK: - Methods
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        tableView.dataSource = presenter
        tableView.delegate = presenter
        tableView.register(ConfigCell.self, forCellReuseIdentifier: TableViewCellNames.configCell)
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TableViewCellNames.transactionCell)
    }
    
    func presentEdit(for transaction: Transaction) {
        let model = TransactionEditModel(transaction: transaction)
        let editVC = UIHostingController(
            rootView: TransactionEditView(
                model: model,
                direction: direction,
                currentMode: .edit
            )
        )
        
        editVC.modalPresentationStyle = .fullScreen
        editVC.presentationController?.delegate = self
        present(editVC, animated: true)
    }
    
    @objc private func handleTransactionUpdate() {
        Task {
            await presenter?.loadTransactions(direction: direction)
        }
    }
}

extension AnalysisViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        Task {
            await presenter?.loadTransactions(direction: direction)
        }
    }
}
