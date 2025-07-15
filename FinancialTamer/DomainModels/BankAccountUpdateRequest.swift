//
//  BankAccountUpdateRequest.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 15.07.2025.
//

import Foundation

struct UpdateAccountRequest: Encodable {
    let name: String
    let balance: Decimal
    let currency: String
}
