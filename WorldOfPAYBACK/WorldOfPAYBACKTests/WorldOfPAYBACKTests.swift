//
//  WorldOfPAYBACKTests.swift
//  WorldOfPAYBACKTests
//
//  Created by Hasan Parves on 30.01.24.
//

import Combine
import XCTest
@testable import WorldOfPAYBACK

@MainActor final class WorldOfPAYBACKTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    private enum TransactionTestError: Error {
        case anyError
        case notImplemented
    }

  private func makeSUT(
        transactionListService: TransactionListService? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> TransactionListViewModel {
        let sut = TransactionListViewModel(
            transactionListService: transactionListService ?? TransactionListServiceSpy(error: TransactionTestError.notImplemented))
            return checkForMemoryLeaks(sut, file: file, line: line)
    }
    
    func testPublishedPropertiesOfViewModel() {
        let sut = makeSUT()
        sut.$transactions.sink{ XCTAssertTrue($0.isEmpty, "Initial transaction list should be empty")}.store(in: &cancellables)
        sut.$isRefreshing.sink{ XCTAssertFalse($0, "Transactionlist should not auto refresh initially")}.store(in: &cancellables)
        sut.$showErrorAlert.sink{ XCTAssertFalse($0, "Transactionlist fetch error alert should not show automatically")}.store(in: &cancellables)
        sut.$selectedCategory.sink{ XCTAssertNil($0, "Category should not preselected")}.store(in: &cancellables)
    }
        
    func testTransactionViewModel() async {
        if let transaction1 = createFakeTransaction1(),  let transaction2 = createFakeTransaction2(), let transaction3 = createFakeTransaction3()
        {
            let sut = makeSUT(transactionListService: TransactionListServiceSpy(result: [transaction1, transaction2, transaction3]))
            await sut.fetchTransactions()
            XCTAssertEqual(sut.transactions.count, 3, "Transaction count mismtach with fake data")
            
        } else {
            XCTFail("Failed to initialize Transaction")
        }
    }
    
    func testTransactionListAPIService() async {
        let apiService = MockTransactionListService(httpClient: HTTPClient())
        let sut = makeSUT(transactionListService: apiService)
        
        do {
            let transactions = try await apiService.loadTransactionList()
            XCTAssertEqual(transactions.count, 21, "Transaction count mismtach with mock data")
            
            await sut.fetchTransactions()
            XCTAssertEqual(sut.transactions.count, 21, "Transaction count mismtach with mock data")
        } catch {
            XCTFail("Error loading transactions: \(error)")
        }
    }
    
    func testTransactionListTotalAmount() async {
        let apiService = MockTransactionListService(httpClient: HTTPClient())
        let sut = makeSUT(transactionListService: apiService)
        await sut.fetchTransactions()
        XCTAssertEqual(sut.sumAmount, 5770.0, "Transaction total amount mismtach")
    }
    
    func testTransactionListCategory1() async {
        let apiService = MockTransactionListService(httpClient: HTTPClient())
        let sut = makeSUT(transactionListService: apiService)
        await sut.fetchTransactions()
        sut.selectedCategory = 1
        XCTAssertEqual(sut.filteredTransactions.count, 13, "Transaction category  type 1 count mismtach")
        XCTAssertEqual(sut.sumAmount, 2711.0, "Transaction total amount mismtach")
    }
    
    func testTransactionListCategory2() async {
        let apiService = MockTransactionListService(httpClient: HTTPClient())
        let sut = makeSUT(transactionListService: apiService)
        await sut.fetchTransactions()
        sut.selectedCategory = 2
        XCTAssertEqual(sut.filteredTransactions.count, 7, "Transaction category  type 2 count mismtach")
        XCTAssertEqual(sut.sumAmount, 2973.0, "Transaction total amount mismtach")
    }
    
    func testTransactionListCategory3() async {
        let apiService = MockTransactionListService(httpClient: HTTPClient())
        let sut = makeSUT(transactionListService: apiService)
        await sut.fetchTransactions()
        sut.selectedCategory = 3
        XCTAssertEqual(sut.filteredTransactions.count, 1, "Transaction category  type 3 count mismtach")
        XCTAssertEqual(sut.sumAmount, 86.0, "Transaction total amount mismtach")
    }
    
    func testTransactionListAPIDateIsNotNil() async {
        let apiService = MockTransactionListService(httpClient: HTTPClient())
        let sut = makeSUT(transactionListService: apiService)
        await sut.fetchTransactions()
        
        XCTAssertFalse(sut.transactions.isEmpty, "Transaction list should not be nil")
        
        for transaction in sut.transactions {
            XCTAssertNotNil(transaction.bookingDate, "Transaction date should not be nil")
        }
    }
    
    func testTransactionInitialization() {
        let jsonData = """
            {
                "partnerDisplayName": "Test Partner",
                "alias": {
                    "reference": "987654"
                },
                "category": 3,
                "transactionDetail": {
                    "description": "Test Transaction",
                    "bookingDate": "2022-03-03T15:45:00+0000",
                    "value": {
                        "amount": 100,
                        "currency": "PBP"
                    }
                }
            }
        """.data(using: .utf8)!
        
        do {
            let transaction = try JSONDecoder().decode(Transaction.self, from: jsonData)
            
            XCTAssertEqual(transaction.partnerDisplayName, "Test Partner")
            XCTAssertEqual(transaction.alias.reference, "987654")
            XCTAssertEqual(transaction.category, 3)
        } catch {
            XCTFail("Failed to initialize Transaction: \(error)")
        }
    }
    
    private func createFakeTransaction1() -> Transaction? {
        let fakeJsonDataTransaction = """
                {
                  "partnerDisplayName" : "REWE Group",
                  "alias" : {
                    "reference" : "066586128163195"
                  },
                  "category" : 1,
                  "transactionDetail" : {
                    "description" : "Punkte sammeln",
                    "bookingDate" : "2022-10-24T10:59:05+0200",
                    "value" : {
                      "amount" : 456,
                      "currency" : "PBP"
                    }
                  }
                }
        """.data(using: .utf8)!
        
        do {
            return try JSONDecoder().decode(Transaction.self, from: fakeJsonDataTransaction)
            
        } catch {
            XCTFail("Failed to initialize Transaction: \(error)")
            return nil
        }
    }
    
    
    private func createFakeTransaction2() -> Transaction? {
        let fakeJsonDataTransaction = """
              {
                "partnerDisplayName" : "Penny-Markt",
                "alias" : {
                  "reference" : "053297453069759"
                },
                "category" : 2,
                "transactionDetail" : {
                  "description" : "Punkte sammeln",
                  "bookingDate" : "2022-02-04T10:59:05+0200",
                  "value" : {
                    "amount" : 2143,
                    "currency" : "PBP"
                  }
                }
              }
        """.data(using: .utf8)!
        
        do {
            return try JSONDecoder().decode(Transaction.self, from: fakeJsonDataTransaction)
            
        } catch {
            XCTFail("Failed to initialize Transaction: \(error)")
            return nil
        }
    }
    
    private func createFakeTransaction3() -> Transaction? {
        let fakeJsonDataTransaction = """
                 {
                   "partnerDisplayName" : "OTTO Group",
                   "alias" : {
                     "reference" : "804558808058663"
                   },
                   "category" : 3,
                   "transactionDetail" : {
                     "description" : "Punkte sammeln",
                     "bookingDate" : "2022-01-18T10:59:05+0200",
                     "value" : {
                       "amount" : 28,
                       "currency" : "PBP"
                     }
                   }
                 }
        """.data(using: .utf8)!
        
        do {
            return try JSONDecoder().decode(Transaction.self, from: fakeJsonDataTransaction)
            
        } catch {
            XCTFail("Failed to initialize Transaction: \(error)")
            return nil
        }
    }

}

