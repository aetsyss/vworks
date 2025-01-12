//
//  BrowseRepository.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 11/1/24.
//

import Foundation

struct BrowseModel {
    let allProductsCount: Int
    let mfCount: Int
    let etfCount: Int
    let plan529Count: Int
}

protocol BrowseRepositoryProtocol {
    func getBrowseModel() async -> BrowseModel
}

class BrowseRepository: BrowseRepositoryProtocol {
    func getBrowseModel() async -> BrowseModel {
        print("getBrowseModel request")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        print("getBrowseModel response")
        return .init(
            allProductsCount: 344,
            mfCount: 267,
            etfCount: 88,
            plan529Count: 33
        )
    }
}

class MockBrowseRepository: BrowseRepositoryProtocol {
    func getBrowseModel() async -> BrowseModel {
        return .init(
            allProductsCount: 344,
            mfCount: 267,
            etfCount: 88,
            plan529Count: 33
        )
    }
}
