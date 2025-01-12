//
//  ResearchRepository.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 11/1/24.
//

import Foundation

struct ResearchModel {
    let showMarketOverview: Bool
    let show529s: Bool
}

protocol ResearchRepositoryProtocol {
    func getResearchModel() async -> ResearchModel
}

class ResearchRepository: ResearchRepositoryProtocol {
    func getResearchModel() async -> ResearchModel {
        print("getResearchModel request")
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        print("getResearchModel response")
        return .init(showMarketOverview: true, show529s: true)
    }
}

class MockResearchRepository: ResearchRepositoryProtocol {
    private let showMarketOverview: Bool
    private let show529s: Bool
    
    init(
        showMarketOverview: Bool,
        show529s: Bool
    ) {
        self.showMarketOverview = showMarketOverview
        self.show529s = show529s
    }
    
    func getResearchModel() async -> ResearchModel {
        .init(
            showMarketOverview: showMarketOverview,
            show529s: show529s
        )
    }
}
