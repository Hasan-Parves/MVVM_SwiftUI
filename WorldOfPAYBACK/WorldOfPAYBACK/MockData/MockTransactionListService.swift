//
//  MockTransactionListService.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 31.01.24.
//

import Foundation

class MockTransactionListService: TransactionListService {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadTransactionList() async throws -> [Transaction] {
        guard let url = Bundle.main.url(forResource: "PBTransactions", withExtension: "json")
        else {
            throw NSError(domain: "MockTransactionListService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Mock json file data not found"])
        }
        let data = try? Data(contentsOf: url)
        try await Task.sleep(nanoseconds: UInt64.random(in: 1...5) * 1_000_000_000) 

        if Int.random(in: 1...50) == 1 {
            throw NSError(domain: "MockTransactionListService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Intentional Random failure"])
        }
        
        do {
            let decodedResult = try JSONDecoder().decode(TransactionResponse.self, from: data!)
            return decodedResult.items.sorted {
                let date1 = $0.bookingDate ?? Date.distantPast
                let date2 = $1.bookingDate ?? Date.distantPast
                return date1 > date2
            }
        } catch {
            throw NSError(domain: "MockTransactionListService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Mock data not found"])
        }
    }
}
