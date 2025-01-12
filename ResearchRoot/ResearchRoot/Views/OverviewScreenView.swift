//
//  OverviewScreenView.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 1/11/25.
//

import SwiftUI

class OverviewScreenViewModel: ObservableObject, @unchecked Sendable {
    enum MarketOverviewSectionState {
        case loading
        case data(MarketIndexesViewModel)
    }
    
    @Published var isMarketOverviewSectionVisible = false
//    @Published var isMarketOverviewDataLoading = false
//    @Published var marketOverviewIndexesViewModel: MarketIndexesViewModel?
    @Published var marketOverviewSectionState: MarketOverviewSectionState?
    
    @MainActor
    func viewDidLoad() async {
        marketOverviewSectionState = .loading
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        withAnimation {
            marketOverviewSectionState = .data(.dumy)
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            withAnimation {
                self.marketOverviewSectionState = .data(
                    .init(
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
                )
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
                        if let state = viewModel.marketOverviewSectionState {
                            Section("Market overview") {
                                switch state {
                                case .loading:
                                    ProgressView()
                                case .data(let model):
                                    MarketIndexesView(model: model)
                                }
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
