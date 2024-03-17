//
//  SideMenuView.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 05.02.24.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isMenuHidden: Bool

    var body: some View {
        VStack {
            Button(action: {
                isMenuHidden = true
            }) {
                Text("Transactions")
                    .foregroundColor(.blue)
            }
            Divider()
            List {
                NavigationLink(destination: FeedView()) {
                    Text("Feed")
                }
                NavigationLink(destination: OnlineShoppingView()) {
                    Text("Online Shopping")
                }
                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}
