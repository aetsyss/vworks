//
//  ContentView.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 10/28/24.
//

import SwiftUI

protocol ResearchRootViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
    func loadData() async
    var marketIndecesViewModel: MarketIndecesViewModel? { get }
    var productsViewModel: ProductsViewModel? { get }
}

@MainActor
class ResearchRootViewModel: ObservableObject, @preconcurrency ResearchRootViewModelProtocol {
    @Published var marketIndecesViewModel: MarketIndecesViewModel?
    @Published var productsViewModel: ProductsViewModel?
    
    var isLoading: Bool {
        marketIndecesViewModel == nil && productsViewModel == nil
    }

    private let marketIndecesRepository: MarketIndecesRepositoryProtocol
    private let researchRepository: ResearchRepositoryProtocol
    private let browseRepository: BrowseRepositoryProtocol
    
    init(
        marketIndecesViewModel: MarketIndecesViewModel? = nil,
        marketIndecesRepository: MarketIndecesRepositoryProtocol = MarketIndecesRepository(),
        researchRepository: ResearchRepositoryProtocol = ResearchRepository(),
        browseRepository: BrowseRepositoryProtocol = BrowseRepository()
    ) {
        self.marketIndecesViewModel = marketIndecesViewModel
        self.marketIndecesRepository = marketIndecesRepository
        self.researchRepository = researchRepository
        self.browseRepository = browseRepository
    }
    
    func loadData() async {
        await loadResearch()
    }
    
    private func loadResearch() async {
        let researchModel = await researchRepository.getResearchModel()
        await handleResearchModel(researchModel)
    }
    
    private func handleResearchModel(_ model: ResearchModel) async {
        if model.showMarketOverview == true {
            await loadMarketOverview()
        } else {
            marketIndecesViewModel = nil
        }
        
        await loadBrowse(show529s: model.show529s)
    }
    
    private func loadBrowse(show529s: Bool) async {
        let browseModel = await browseRepository.getBrowseModel()
        await handleBrowseModel(browseModel, show529s: show529s)
    }
    
    private func handleBrowseModel(_ model: BrowseModel, show529s: Bool) async {
        if show529s {
            productsViewModel = .init(products: [
                .init(name: "Mutual funds", count: model.mfCount),
                .init(name: "ETFs", count: model.etfCount),
                .init(name: "529 plans", count: model.plan529Count)
            ])
        } else {
            productsViewModel = .init(products: [
                .init(name: "All products", count: model.allProductsCount),
                .init(name: "Mutual funds", count: model.mfCount),
                .init(name: "ETFs", count: model.etfCount),
            ])
        }
    }
    
    private func loadMarketOverview() async {
        /// Load Market indeces data
        marketIndecesViewModel = .init(state: .loading)
        
        await marketIndecesViewModel = .init(
            state: .data(marketIndecesRepository.getMarketIndecesData())
        )
        
        /// Start the Market indeces refresh timer
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            Task { @MainActor in
                await self.marketIndecesViewModel = .init(
                    state: .data(self.marketIndecesRepository.getMarketIndecesData())
                )
            }
        }
    }
}

@MainActor
class ResearchRootViewModelStateDriven: ObservableObject {
    private let marketIndecesRepository: MarketIndecesRepositoryProtocol
    private let researchRepository: ResearchRepositoryProtocol
    private let browseRepository: BrowseRepositoryProtocol
    
    init(
        marketIndecesRepository: MarketIndecesRepositoryProtocol = MarketIndecesRepository(),
        researchRepository: ResearchRepositoryProtocol = ResearchRepository(),
        browseRepository: BrowseRepositoryProtocol = BrowseRepository()
    ) {
        self.marketIndecesRepository = marketIndecesRepository
        self.researchRepository = researchRepository
        self.browseRepository = browseRepository
    }
    
    struct Data {
        var marketIndecesViewModel: MarketIndecesViewModel?
        var productsViewModel: ProductsViewModel?
    }
    
    enum State {
        case loading
        case data
    }
    
    @Published var state: State?
    
    private var data = Data()
    
    var isLoading: Bool {
        switch state {
        case .loading: true
        default: false
        }
    }
    
    var marketIndecesViewModel: MarketIndecesViewModel? {
        switch state {
        case .data: data.marketIndecesViewModel
        default: nil
        }
    }
    
    var productsViewModel: ProductsViewModel? {
        switch state {
        case .data: data.productsViewModel
        default: nil
        }
    }
    
    func loadData() async {
        state = .loading
        
        async let researchModel = await researchRepository.getResearchModel()
        
        if await researchModel.showMarketOverview {
            data.marketIndecesViewModel = .init(state: .loading)
            state = .data
        }
    }
}

struct ResearchRootView<ViewModel: ResearchRootViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else {
                dataView
            }
        }
        .navigationTitle("Research")
        .task {
            await viewModel.loadData()
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
            Text("Loading")
        }
    }
    
    private var dataView: some View {
        ScrollView(.vertical) {
            VStack(spacing: 40) {
                if let marketIndecesViewModel = viewModel.marketIndecesViewModel {
                    MarketIndecesView(viewModel: marketIndecesViewModel)
                }
                
                if let productsViewModel = viewModel.productsViewModel {
                    ProductsView(viewModel: productsViewModel)
                }
            }
            .padding()
        }
    }
}

#Preview {
    NavigationView {
        ResearchRootView(
            viewModel: ResearchRootViewModel(
                marketIndecesRepository: MockMarketIndecesRepository(),
                researchRepository: MockResearchRepository(
                    showMarketOverview: true,
                    show529s: true
                ),
                browseRepository: MockBrowseRepository()
            )
        )
    }
}

#Preview {
    NavigationView {
        ResearchRootView(
            viewModel: ResearchRootViewModel(
                marketIndecesRepository: MockMarketIndecesRepository(),
                researchRepository: MockResearchRepository(
                    showMarketOverview: false,
                    show529s: false
                ),
                browseRepository: MockBrowseRepository()
            )
        )
    }
}
