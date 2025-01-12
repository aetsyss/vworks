//
//  MarketIndecesRepository.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 10/30/24.
//

import Foundation

protocol MarketIndecesRepositoryProtocol {
    func getMarketIndecesData() async -> [MarketIndex]
}

class MarketIndecesRepository: MarketIndecesRepositoryProtocol {
    /// Provides Market indeces data
    func getMarketIndecesData() async -> [MarketIndex] {
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        return .dummy()
    }
}

class MockMarketIndecesRepository: MarketIndecesRepositoryProtocol {
    /// Provides Market indeces data
    func getMarketIndecesData() async -> [MarketIndex] {
        .dummy()
    }
}
