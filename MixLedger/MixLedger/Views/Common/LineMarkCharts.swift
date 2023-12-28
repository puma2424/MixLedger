//
//  LineMarkCharts.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/27.
//

import Charts
import SwiftUI

struct LineMarkCharts: View {
    @State private var saveData = SaveData.shared
//    @State var vm = StockEntityViewModel()
    var stockData: [TransactionForChart] = [
        .init(amount: 100, date: Date(), subType: "play", mainType: "ex"),
        .init(amount: 30, date: Date.from(inputYear: 2023, inputMon: 11, inputDay: 3), subType: "food", mainType: "ex"),
        .init(amount: 30, date: Date.from(inputYear: 2023, inputMon: 11, inputDay: 3), subType: "qqq", mainType: "ex"),
        .init(amount: 30, date: Date.from(inputYear: 2023, inputMon: 11, inputDay: 29), subType: "food", mainType: "ex"),
        .init(amount: 300, date: Date.from(inputYear: 2023, inputMon: 11, inputDay: 29), subType: "play", mainType: "ex"),
    ]
    var body: some View {
        VStack {
            Text("Monthly Expenses")
                .foregroundColor(.g1)

            Text("Total: \(String(format: "%.1f", stockData.reduce(0) { $0 + $1.amount }))")
                .fontWeight(.semibold)
                .font(.footnote)
                .foregroundStyle(.secondary)
//                .foregroundColor(.g2)
                .padding(.bottom, 12)

            Chart {
                ForEach(stockData) { data in
                    BarMark(
                        x: .value("Date", data.date, unit: .month),
                        y: .value("amount", data.amount)
                    )
                    .foregroundStyle(by: .value("Product Category", data.subType))
                }
            }
//            .chartXAxis {
//                AxisMarks(values: stockData.map { $0.date }) { _ in
//                    AxisValueLabel(format: .dateTime.month(.defaultDigits), centered: true, offsetsMarks: true)
//                }
//            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXScale(domain: Date.from(inputMon: 1, inputDay: 1) ... Date.from(inputMon: 12, inputDay: 31), type: .linear)
            .chartXAxisLabel("Date (\(Date.getNowYearInt()))", alignment: .leading)
            .chartYAxisLabel("Price (NTD)", alignment: .leading)
            .frame(height: 300)
        }
        .padding()
    }
}

struct LineMarkCharts_Previews: PreviewProvider {
    static var previews: some View {
        LineMarkCharts()
    }
}

extension Date {
    static func getNowYearInt(data _: Date = Date()) -> Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        return year
    }

    static func from(inputYear: Int = getNowYearInt(), inputMon: Int, inputDay: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year], from: Date())

        components.year = inputYear
        components.month = inputMon
        components.day = inputDay
        return Calendar.current.date(from: components)!
    }
}
