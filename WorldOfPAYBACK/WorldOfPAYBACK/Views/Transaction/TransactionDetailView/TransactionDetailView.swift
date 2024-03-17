//
//  TransactionDetailView.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 04.02.24.
//

import SwiftUI

struct TransactionDetailView: View {
    let transaction: Transaction

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Partner:\n\(transaction.partnerDisplayName)")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            Text("Description:\n\(transaction.transactionDetail.description ?? "")")
                .font(.headline)
                .multilineTextAlignment(.leading)
                .accessibility(identifier: "detailsText")
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 32)
        .padding(.leading, 24)
        .navigationTitle("transactionDetails")
    }
}


