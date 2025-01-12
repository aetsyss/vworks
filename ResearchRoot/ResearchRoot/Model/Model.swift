//
//  Model.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 10/28/24.
//

import Foundation

struct MarketIndex: Identifiable {
    let id: UUID = UUID()
    let name: String
    var price: String
}

extension [MarketIndex] {
    static func dummy() -> Self {
        [
            .init(name: "S&P 500", price: "$" + Int.random(in: 234...9999).description),
            .init(name: "D&J", price: "$" + Int.random(in: 234...9999).description),
            .init(name: "NASDAQ", price: "$" + Int.random(in: 234...9999).description)
        ]
    }
}
