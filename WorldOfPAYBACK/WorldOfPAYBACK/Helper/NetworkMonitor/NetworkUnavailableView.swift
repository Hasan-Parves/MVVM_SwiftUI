//
//  NetworkUnavailableView.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 05.02.24.
//

import SwiftUI

struct NetworkUnavailableView: View {
    var body: some View {
        ContentUnavailableView( // if iOS 17 available use the default one
            icon: "wifi.exclamationmark",
            title: "No Internet Connection",
            subtitle: "Please check your connection and try again."
        )
    }
}

struct ContentUnavailableView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.gray)
                .padding(.horizontal, 12)
                .padding(.leading, 7)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.red)
                
                Text(subtitle)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
    }
}
