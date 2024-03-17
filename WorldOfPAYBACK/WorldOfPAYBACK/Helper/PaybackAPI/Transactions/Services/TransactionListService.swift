//
//  TransactionListService.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

import Foundation

protocol TransactionListService {
    func loadTransactionList() async throws -> [Transaction]
}

struct TransactionListAPIService: TransactionListService {
    private let httpClient: HTTPClient
    private let shouldLoadTestData: Bool
    
    public init(httpClient: HTTPClient, useTestData: Bool = false) {
        self.httpClient = httpClient
        self.shouldLoadTestData = useTestData
    }
    
    func loadTransactionList() async throws -> [Transaction] {
        try await httpClient.request(Endpoints.Transactions.GetTransactions())
    }
}
