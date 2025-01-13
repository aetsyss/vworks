//
//  OverviewScreenView.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 1/11/25.
//

import SwiftUI

protocol OverviewScreenViewModelProtocol: ObservableObject {
    /// Is Market overview section visible.
    var isMarketOverviewSectionVisible: Bool { get }
    
    /// Market indexes view model.
    var marketIndexesViewModel: MarketIndexesViewModel? { get }
    
    /// View did load.
    func viewDidLoad() async
}

struct OverviewScreenView<ViewModel>: View where ViewModel: OverviewScreenViewModelProtocol {
    @ObservedObject var viewModel: ViewModel
    
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
