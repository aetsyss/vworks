//
//  ProductsView.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 11/1/24.
//

import SwiftUI

struct ProductsViewModel {
    struct Product: Identifiable {
        let id: UUID = .init()
        let name: String
        let count: Int
    }
    
    let products: [Product]
}

struct ProductsView: View {
    let viewModel: ProductsViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Vanguard products")
                    .font(.title.bold())
                Spacer()
            }
            
            VStack(spacing: 10) {
                ForEach(viewModel.products) { product in
                    HStack {
                        Text(product.name)
                            .font(.title2)
                        Spacer()
                        Text(product.count.description)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    ProductsView(
        viewModel: .init(products: [
            .init(name: "All products", count: 100),
            .init(name: "Mutual funds", count: 70),
            .init(name: "ETFs", count: 30)
        ])
    )
}
