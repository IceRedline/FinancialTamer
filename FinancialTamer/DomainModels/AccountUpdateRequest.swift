//
//  BankAccountUpdateRequest.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 15.07.2025.
//

import Foundation

struct AccountUpdateRequest: Encodable {
    let name: String
    let balance: Decimal
    let currency: String
}
