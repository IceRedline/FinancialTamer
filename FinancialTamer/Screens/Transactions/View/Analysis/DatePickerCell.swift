//
//  DatePickerCell.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 04.07.2025.
//

import UIKit

class DatePickerCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let datePicker = UIDatePicker()
    
    private var onDateChanged: ((Date) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupViews() {
        titleLabel.font = .systemFont(ofSize: 17)
        [titleLabel, valueLabel, datePicker].forEach { x in
            contentView.addSubview(x)
            x.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = .accentLight
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        valueLabel.isHidden = true
        datePicker.isHidden = true
    }

    func configure(title: String, date: Date, onChange: @escaping (Date) -> Void) {
        titleLabel.text = title
        datePicker.isHidden = false
        valueLabel.isHidden = true
        datePicker.date = date
        self.onDateChanged = onChange
    }

    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
        valueLabel.isHidden = false
        datePicker.isHidden = true
    }

    @objc private func dateChanged() {
        onDateChanged?(datePicker.date)
    }
}
