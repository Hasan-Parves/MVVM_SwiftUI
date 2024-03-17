//
//  TransactionCellView.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 04.02.24.
//

import SwiftUI

struct TransactionCellView: View {
    var transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                transactionDateAndTimeView
                transactionPartnerAndDescriptionView
                transactionAmountDetailsView
            }
            Spacer()
            transactionAmountViewWithIcon
        }
    }
    
    @ViewBuilder private var transactionDateAndTimeView: some View {
        if let bookingDate = transaction.bookingDate {
            HStack {
                Image(systemName: "calendar")
                    .padding(4)
                Text("\(bookingDate.toDateString())")
                    .font(.subheadline)
                Image(systemName: "clock")
                    .padding(4)
                Text("\(bookingDate.toTimeString())")
                    .font(.subheadline)
            }
        }
    }
    
    @ViewBuilder private var transactionPartnerAndDescriptionView: some View {
        Text("Partner: \(transaction.partnerDisplayName)")
            .font(.headline)
        if let description = transaction.transactionDetail.description {
            Text("Description: \(description)")
                .font(.subheadline)
        }
    }
    
    @ViewBuilder private var transactionAmountDetailsView: some View {
        HStack {
            Text("Amount: \(transaction.transactionDetail.value.amount)")
                .font(.subheadline)
            Text("Currency: \(transaction.transactionDetail.value.currency)")
                .font(.subheadline)
        }
    }
    
    @ViewBuilder private var transactionAmountViewWithIcon: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack {
                Image(systemName: "coloncurrencysign.circle")
                Text("\(transaction.transactionDetail.value.amount) \(transaction.transactionDetail.value.currency)")
                    .font(.subheadline)
            }
        }
    }
}
