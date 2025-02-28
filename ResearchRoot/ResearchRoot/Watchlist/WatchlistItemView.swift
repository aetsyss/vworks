//
//  WatchlistItemView.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 2/28/25.
//

import SwiftUI

struct WatchlistItemView: View {
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading) {
                HStack(alignment: .lastTextBaseline) {
                    Text("VTSAX")
                        .font(.title).bold()
                    Text("MF")
                        .foregroundStyle(.secondary)
                }
                
                Text("Vanguard Total Stock Market Index ETF")
                    .lineLimit(2)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("$764,484")
                .fixedSize()
                .font(.title2).bold()
            
            HStack(spacing: 4) {
                Text("3.47%")
                Text("$11,104")
            }
            .fixedSize()
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Capsule().fill(Color.green.opacity(0.5)))
        }
    }
}

#Preview {
    WatchlistItemView()
}
