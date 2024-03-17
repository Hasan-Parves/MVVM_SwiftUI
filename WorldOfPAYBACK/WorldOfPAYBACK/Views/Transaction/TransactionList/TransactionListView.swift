//
//  TransactionListView.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 31.01.24.
//

import Foundation
import SwiftUI

struct TransactionListView: View {
    @StateObject private var viewModel: TransactionListViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    public init(transactionListService: TransactionListService) {
        _viewModel = StateObject(
            wrappedValue: TransactionListViewModel(
                transactionListService: transactionListService
            )
        )
    }
    
    var body: some View {
        if !networkMonitor.isConnected {
            NetworkUnavailableView()
        } else {
            NavigationStack {
                VStack(spacing: 0) {
                    categoryPickerviewView
                    transactionListView
                }
                .refreshable {
                    viewModel.isRefreshing = true
                    await viewModel.fetchTransactions()
                }
                .overlay(
                    pullToRefreshView
                )
                .navigationTitle("transaction")
            }
            .task {
                viewModel.isRefreshing = true
                await viewModel.fetchTransactions()
            }
            .onChange(of: viewModel.transactions) { _ in
                viewModel.isRefreshing = false
            }
            .alert(isPresented: $viewModel.showErrorAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorAlertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    @ViewBuilder private var categoryPickerviewView: some View {
        HStack {
            Picker("selecteCategory", selection: $viewModel.selectedCategory) {
                Text("All").tag(nil as Int?)
                ForEach(Array(Set(viewModel.transactions.map { $0.category })).sorted(), id: \.self) { category in
                    Text("Category: \(category)").tag(category as Int?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            Text("selecteCategory \(viewModel.selectedCategory.map(String.init) ?? "All")")
        }
    }
    
    @ViewBuilder private var transactionListView: some View {
        List {
            totalAmountSectionView
            transactionListSectionView
        }
        .listStyle(PlainListStyle())
        .accessibility(identifier: "transactionList")
    }
    
    @ViewBuilder private var totalAmountSectionView: some View {
        Section(header:
                    HStack {
            Text("total_value")
            Spacer()
            Text("\(viewModel.sumAmount)") // Total value of all currency type for a category type
        }
        ) {
            totalAmountView
        }
        .listSectionSeparator(.hidden)
    }
    
    /* This list will show a list of diffrenct currency with their repective total for a category type : in mock data only one type of currency provided but if the different curency type is provided this list can handle that.*/
    @ViewBuilder private var totalAmountView: some View {
        ForEach(viewModel.currencySums.sorted(by: { $0.key < $1.key }), id: \.key) { currency, sum in
            HStack {
                Text("sumOfCurrencyType \(currency):")
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "coloncurrencysign.circle")
                Text("\(sum) \(currency)")
                    .fontWeight(.bold)
                    .font(.headline)
            }
        }
    }
    
    @ViewBuilder private var transactionListSectionView: some View {
        Section(header: Text("transactionListForCategory \(viewModel.selectedCategory.map(String.init) ?? "All")")) {
            transactionCellView
        }
    }
    
    @ViewBuilder private var transactionCellView: some View {
        ForEach(viewModel.filteredTransactions, id: \.alias.reference) { transaction in
            NavigationLink(destination: TransactionDetailView(transaction: transaction)) {
                TransactionCellView(transaction: transaction)
            }
        }
    }
    
    @ViewBuilder private var pullToRefreshView: some View {
        if viewModel.isRefreshing {
            VStack {
                ProgressView("transactionLoading")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.opacity(0.8))
        } else {
            EmptyView()
        }
    }
}
