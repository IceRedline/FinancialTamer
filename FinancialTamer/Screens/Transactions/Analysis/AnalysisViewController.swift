//
//  AnalysisViewController.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 04.07.2025.
//

import UIKit

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
        
        title = "Анализ"
        view.backgroundColor = .systemGroupedBackground
        
        presenter?.attach(viewController: self)
        setupTableView()
        presenter?.viewDidLoad()
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
}
