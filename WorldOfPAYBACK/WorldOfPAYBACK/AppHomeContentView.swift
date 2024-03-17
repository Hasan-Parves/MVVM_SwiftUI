//
//  AppHomeContentView.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

import SwiftUI

struct AppHomeContentView: View {
    @State private var isMenuHidden = true

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    if isMenuHidden {
                        TransactionView()
                    } else {
                        SideMenuView(isMenuHidden: $isMenuHidden)
                            .frame(width: geometry.size.width * 0.8)
                            .transition(.move(edge: .leading))
                    }
                }
            }
            .navigationBarItems(leading: Button(action: {
                withAnimation {
                    isMenuHidden.toggle()
                }
            }) {
                Image(systemName: "line.horizontal.3")
                    .imageScale(.large)
            }
                .accessibility(identifier: "side_menu_button")
            )
        }
    }
}

struct TransactionView: View {
    @StateObject var networkMonitor = NetworkMonitor()

    var body: some View {
        let useMockData = Bundle.main.object(forInfoDictionaryKey: "USE_MOCK_DATA") as! Bool
        let useTestData = Bundle.main.object(forInfoDictionaryKey: "USE_TEST_DATA") as! Bool
        if useMockData {
            let transactionListService: TransactionListService = MockTransactionListService(httpClient: HTTPClient())
            TransactionListView(transactionListService: transactionListService)
                .environmentObject(networkMonitor)
        } else if useTestData {
            /* Extension HTTPEndpoint also have this check for test data server in basePath, but we can also call this from here as well. I like to inject dependancy in calling.*/
            let transactionListService: TransactionListService = TransactionListAPIService(httpClient: HTTPClient(shouldUseTestServer: useTestData))
            TransactionListView(transactionListService: transactionListService)
                .environmentObject(networkMonitor)
        } else {
            let transactionListService: TransactionListService = TransactionListAPIService(httpClient: HTTPClient())
            TransactionListView(transactionListService: transactionListService)
                .environmentObject(networkMonitor)
        } 
    }
}
