//
//  SwiftDataOperationsStorage.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 16.07.2025.
//

import Foundation
import SwiftData

final class TransactionsStorage: TransactionsStorageProtocol {
    
    private let modelContainer: ModelContainer
    private let context: ModelContext
    
    @MainActor
    init() throws {
        let schema = Schema([LocalTransaction.self])
        self.modelContainer = try ModelContainer(for: schema)
        self.context = modelContainer.mainContext
    }
    
    func fetchAll() throws -> [LocalTransaction] {
        let descriptor = FetchDescriptor<LocalTransaction>()
        return try context.fetch(descriptor)
    }
    
    func add(_ transaction: LocalTransaction) throws {
        context.insert(transaction)
        try context.save()
    }
    
    func update(_ transaction: LocalTransaction) throws {
        try context.save()
    }
    
    func delete(withId id: Int) throws {
        let descriptor = FetchDescriptor<LocalTransaction>(predicate: #Predicate { $0.id == id })
        if let object = try context.fetch(descriptor).first {
            context.delete(object)
            try context.save()
        }
    }
}
