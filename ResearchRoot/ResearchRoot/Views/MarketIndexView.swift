//
//  MarketIndexView.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 1/11/25.
//

import SwiftUI
import Charts

struct MarketIndexViewModel: Identifiable {
    struct Chart {
        let points: [Double]
        let color: Color
    }
    
    struct StyledText {
        let text: String
        let color: Color
    }
    
    let name: String
    let nameWidth: CGFloat
    let chart: Chart
    var value: String
    let valueWidth: CGFloat
    let diffs: [StyledText]
    
    var id: String { name }
}

struct MarketIndexView: View {
    let model: MarketIndexViewModel
    
    @State private var diffsIndex = 0
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Index Name
            Self.nameView(model.name)
                .frame(width: model.nameWidth, alignment: .leading)
            
            // Line Chart
            Chart {
                ForEach(model.chart.points.indices, id: \ .self) { index in
                    LineMark(
                        x: .value("Index", index),
                        y: .value("Value", model.chart.points[index])
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(model.chart.color)
                }
                RuleMark(y: .value("Midline", (model.chart.points.min()! + model.chart.points.max()!) / 2))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundStyle(Color.gray)
            }
            .chartYAxis(.hidden)
            .chartXAxis(.hidden)
            .frame(height: 50)
            
            // Index Value
            Self.valueView(model.value)
                .frame(width: model.valueWidth, alignment: .trailing)
            
            // Value Change
            Text(model.diffs[diffsIndex].text)
                .fixedSize()
                .foregroundStyle(model.chart.color)
                .frame(width: 50, alignment: .trailing)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 20000, repeats: true) { _ in
                        diffsIndex = diffsIndex == model.diffs.count - 1 ? 0 : diffsIndex + 1
                    }
                }
        }
        .padding()
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.secondary.opacity(0.7), lineWidth: 1)
        )
    }
    
    static func nameView(_ value: String) -> some View {
        Text(value)
            .font(.headline)
            .fixedSize()
    }
    
    static func valueView(_ value: String) -> some View {
        Text(value)
            .fixedSize()
            .bold()
    }
}

extension MarketIndexViewModel {
    static let sp500 = MarketIndexViewModel(
        name: "S&P 500",
        nameWidth: 80,
        chart: .init(
            points: [10, 20, 50, 4, 8, 40, 30, 14, 2, 8, 10, 45, 16],
            color: .red
        ),
        value: "4100.12",
        valueWidth: 80,
        diffs: [
            .init(text: "+50.12", color: .green),
            .init(text: "+12.68%", color: .green)
        ]
    )
    
    static let djia = MarketIndexViewModel(
        name: "DJIA",
        nameWidth: 50,
        chart: .init(
            points: [10, 20, 50, 4, 8, 40, 30, 14, 2, 8, 10, 45, 16, 18, 24, 0, 56, 8, 7],
            color: .red
        ),
        value: "9.10",
        valueWidth: 80,
        diffs: [
            .init(text: "-5.60", color: .red),
            .init(text: "-1.68%", color: .red)
        ]
    )
    
    static let nasdaq = MarketIndexViewModel(
        name: "NASDAQ",
        nameWidth: 50,
        chart: .init(
            points: [0, 1, 4, 50, 56, 12, 57],
            color: .green
        ),
        value: "56.18",
        valueWidth: 80,
        diffs: [
            .init(text: "-15.60", color: .red),
            .init(text: "-10.68%", color: .red)
        ]
    )
    
    static func random(name: String) -> MarketIndexViewModel {
        MarketIndexViewModel(
            name: name,
            nameWidth: 50,
            chart: .init(
                points: (0..<20).map({ _ in Double(Int.random(in: 0...100)) }),
                color: .green
            ),
            value: String(Int.random(in: 10...100)),
            valueWidth: 80,
            diffs: [
                .init(text: String(Int.random(in: 10...100)) + "%", color: .red),
                .init(text: String(Int.random(in: 10...100)) + "%", color: .red)
            ]
        )
    }
}

#Preview {
    MarketIndexView(model: .sp500)
    .padding(.horizontal)
}
