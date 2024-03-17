//
//  TransactionListServiceSpy.swift
//  WorldOfPAYBACKTests
//
//  Created by Hasan Parves on 05.02.24.
//

import Foundation
@testable import WorldOfPAYBACK

public final class TransactionListServiceSpy: TransactionListService {
    public init(result: [WorldOfPAYBACK.Transaction]) {
        self.result = result
        error = nil
    }
    public init(error: any Error) {
        result = nil
        self.error = error
    }
    
    private let result: [WorldOfPAYBACK.Transaction]?
    private let error: (any Error)?
    
    public func loadTransactionList() async throws -> [WorldOfPAYBACK.Transaction] {
        
        if let error {
            throw error
        }
        return result!
    }
}
