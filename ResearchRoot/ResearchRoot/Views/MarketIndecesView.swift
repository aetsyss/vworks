//
//  MarketIndecesView.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 10/28/24.
//

import SwiftUI

struct MarketIndecesViewModel {
    enum State {
        case loading
        case data([MarketIndex])
    }
    
    let state: State
}

struct MarketIndecesView: View {
    let viewModel: MarketIndecesViewModel
    
    var body: some View {
        
        VStack(spacing: 20) {
            HStack {
                Text("Market overview")
                    .font(.title.bold())
                Spacer()
            }
            VStack(spacing: 10) {
                switch viewModel.state {
                case .loading:
                    ForEach(0..<3) { _ in
                        HStack {
                            Text("      ")
                            Spacer()
                            Text("      ")
                        }
                        .font(.title2)
                        .redacted(reason: .placeholder)
                    }
                case let .data(marketIndeces):
                    ForEach(marketIndeces) { marketIndex in
                        HStack {
                            Text(marketIndex.name)
                            Spacer()
                            Text(marketIndex.price)
                        }
                        .font(.title2)
                    }
                }
                
            }
        }
    }
}

#Preview {
    VStack(spacing: 100) {
        MarketIndecesView(
            viewModel: .init(
                state: .data(.dummy())
            )
        )
        
        MarketIndecesView(
            viewModel: .init(
                state: .loading
            )
        )
    }
}
