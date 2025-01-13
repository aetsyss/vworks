//
//  OverviewScreenView.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 1/11/25.
//

import SwiftUI

class OverviewScreenViewModel: ObservableObject, @unchecked Sendable {
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

struct OverviewScreenView: View {
    @ObservedObject var viewModel: OverviewScreenViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    if viewModel.isMarketOverviewSectionVisible {
                        if let marketOverviewSectionData = viewModel.marketIndexesViewModel {
                            Section("Market overview") {
                                MarketIndexesView(model: marketOverviewSectionData)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Overview")
        }
        .task {
            await viewModel.viewDidLoad()
        }
    }
}

extension OverviewScreenView {

    struct Section<Content>: View where Content: View {
        let title: any StringProtocol
        let content: () -> Content
        
        init(
            _ title: any StringProtocol,
            @ViewBuilder content: @escaping () -> Content
        ) {
            self.title = title
            self.content = content
        }
        
        var body: some View {
            VStack(spacing: 16) {
                Text(title)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                content()
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    let viewModel = OverviewScreenViewModel()
    viewModel.isMarketOverviewSectionVisible = true
    
    return OverviewScreenView(viewModel: viewModel)
}
