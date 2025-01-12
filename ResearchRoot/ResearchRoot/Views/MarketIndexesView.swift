//
//  MarketIndexesView.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 1/11/25.
//

import SwiftUI

struct MarketIndexesViewModel {
    let asOfDate: String
    let indexes: [MarketIndexViewModel]
    let indexTapCallback: (MarketIndexViewModel) -> Void
}

struct MarketIndexesView: View {
    let model: MarketIndexesViewModel
    
    @State private var widths: [PartialKeyPath<MarketIndexViewModel>: CGFloat] = [:]
    
    var body: some View {
        VStack {
            HStack {
                Text("as of \(model.asOfDate)")
                    .italic()
                    .foregroundStyle(.secondary)
                Spacer()
            }
                
            ForEach(model.indexes) { index in
                Button {
                    model.indexTapCallback(index)
                } label: {
                    MarketIndexView(
                        model: .init(
                            name: index.name,
                            nameWidth: widths[\.name, default: 0],
                            chart: index.chart,
                            value: index.value,
                            valueWidth: widths[\.value, default: 0],
                            diffs: index.diffs
                        )
                    )
                }
//                .buttonStyle(.plain)
                .buttonStyle(CustomButtonStyle())
            }
        }
        .dynamicColumnSize(items: model.indexes, keyPath: \.name, storage: $widths) {
            MarketIndexView.nameView($0)
        }
        .dynamicColumnSize(items: model.indexes, keyPath: \.value, storage: $widths) {
            MarketIndexView.valueView($0)
        }
    }
}

extension MarketIndexesViewModel {
    static let dumy = MarketIndexesViewModel(
        asOfDate: "10/12/2024 9:55 AM",
        indexes: [.sp500, .djia, .nasdaq],
        indexTapCallback: { marketIndex in
            print("Did tap \(marketIndex)")
        }
    )
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.gray.opacity(0.1) : Color.clear)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}


#Preview {
    MarketIndexesView(model: .dumy)
    .padding(.horizontal)
}
