//
//  MarketIndexesView.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 1/11/25.
//

import SwiftUI

struct MarketIndexesViewModel {
    enum State {
        case loading
        case data(Data)
    }
    
    struct Data {
        let asOfDate: String
        var indexes: [MarketIndexViewModel]
        let indexTapCallback: (MarketIndexViewModel) -> Void
    }
    
    let state: State
}

struct MarketIndexesView: View {
    let model: MarketIndexesViewModel
    
    @State private var widths: [PartialKeyPath<MarketIndexViewModel>: CGFloat] = [:]
    
    var body: some View {
        switch model.state {
        case .loading:
            ProgressView()
        case .data(let data):
            VStack {
                HStack {
                    Text("as of \(data.asOfDate)")
                        .italic()
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                    
                ForEach(data.indexes) { index in
                    Button {
                        data.indexTapCallback(index)
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
                    .buttonStyle(CustomButtonStyle())
                }
            }
            .dynamicColumnSize(items: data.indexes, keyPath: \.name, storage: $widths) {
                MarketIndexView.nameView($0)
            }
            .dynamicColumnSize(items: data.indexes, keyPath: \.value, storage: $widths) {
                MarketIndexView.valueView($0)
            }
        }
    }
}

extension MarketIndexesViewModel {
    static let dumy = MarketIndexesViewModel(
        state: .data(
            .init(
                asOfDate: "10/12/2024 9:55 AM",
                indexes: [.sp500, .djia, .nasdaq],
                indexTapCallback: { marketIndex in
                    print("Did tap \(marketIndex)")
                }
            )
        )
    )
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.gray.opacity(0.1) : Color.clear)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
//            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}


#Preview {
    MarketIndexesView(model: .dumy)
    .padding(.horizontal)
}
