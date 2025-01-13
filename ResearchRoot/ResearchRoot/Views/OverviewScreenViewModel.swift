//
//  OverviewScreenViewModel.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 1/13/25.
//

import SwiftUI

class OverviewScreenViewModel: ObservableObject, OverviewScreenViewModelProtocol, @unchecked Sendable {
    @Published var isMarketOverviewSectionVisible = false
    @Published private var isMarketOverviewDataLoading = false
    @Published private var marketOverviewData: MarketIndexesViewModel.Data?
    
    var marketIndexesViewModel: MarketIndexesViewModel? {
        if isMarketOverviewDataLoading {
            return .init(state: .loading)
        } else if let data = marketOverviewData {
            return .init(state: .data(data))
        } else {
            return nil
        }
    }
    
    @MainActor
    func viewDidLoad() async {
        isMarketOverviewDataLoading = true
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        withAnimation {
            isMarketOverviewDataLoading = false
            marketOverviewData = .init(
                asOfDate: "10/12/2024 9:55 AM",
                indexes: [
                    .random(name: "S&P 500"),
                    .random(name: "DJIA"),
                    .random(name: "NASDAQ")
                ],
                indexTapCallback: { marketIndex in
                    print("Did tap \(marketIndex)")
                }
            )
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            withAnimation {
                self.marketOverviewData?.indexes[0].value = String(Int.random(in: 1000...10000))
                self.marketOverviewData?.indexes[1].value = String(Int.random(in: 1000...10000))
                self.marketOverviewData?.indexes[2].value = String(Int.random(in: 1000...10000))
            }
        }
    }
}
