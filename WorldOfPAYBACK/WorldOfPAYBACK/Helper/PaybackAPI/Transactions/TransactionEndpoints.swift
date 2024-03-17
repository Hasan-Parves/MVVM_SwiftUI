//
//  TransactionEndpoints.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

import Foundation

extension Endpoints {
    enum Transactions {
        struct GetTransactions: HTTPEndpoint {
            let path = "transactions/"
            let decoder = JSONResponseDecoder<[Transaction]>()
        }
    }
}
