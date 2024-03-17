//
//  TransactionListViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 31.01.24.
//

import Combine
import Foundation

@MainActor final class TransactionListViewModel: ObservableObject {
    @Published private (set) var transactions: [Transaction] = []
    @Published var isRefreshing: Bool = false
    @Published var selectedCategory: Int?
    @Published var showErrorAlert: Bool = false
    @Published var errorAlertMessage: String = ""
    
    private let transactionListService: any TransactionListService
    
    init(transactionListService: any TransactionListService) {
        self.transactionListService = transactionListService
    }
    
    var filteredTransactions: [Transaction] {
        if let selectedCategory = selectedCategory {
            return transactions.filter { $0.category == selectedCategory }
        } else {
            return transactions
        }
    }
    
    // Specific currency sum (if there are different kind of currency)
    var currencySums: [String: Int] {
        var sums: [String: Int] = [:]
        for transaction in filteredTransactions {
            let currency = transaction.transactionDetail.value.currency
            let amount = transaction.transactionDetail.value.amount
            
            sums[currency, default: 0] += amount
        }
        return sums
    }
    
    // For total amount of all transaction of a category regardless of different currency
    var sumAmount: Double {
        filteredTransactions.map { Double($0.transactionDetail.value.amount) }.reduce(0.0, +)
    }
    
    func fetchTransactions() async {
        defer {
            isRefreshing = false
        }
        do {
            transactions.removeAll()
            // TODO:: Pagination in future when api ready for pagination
            let fetchedTransactions = try await transactionListService.loadTransactionList()
            transactions += fetchedTransactions
        } catch RemoteError.badRequest(statusCode: 404) {
            print("Loading Transaction Failed: Bad request")
            showErrorAlert(message: "Loading Transaction Failed: Bad request")
        } catch {
            print("Loading Transaction Failed: \(error)")
            showErrorAlert(message: "Loading Transaction Failed: \(error)")
        }
    }
    
    private func showErrorAlert(message: String) {
        errorAlertMessage = message
        showErrorAlert = true
    }
}
