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
//        .init(amount: 0, date: Date()),
//        .init(amount: 2, date: Date())
    ]
    var body: some View {
        VStack {
            Chart {
//                ForEach(vm.stockData) { data in
                ForEach(stockData) { data in
                    BarMark(
                        x: .value("Date", data.date, unit: .month),
                        y: .value("amount", data.amount)
                    )
//                    .foregroundStyle(by: .value("Stock Name", data.date)) // 4：左下角的圖例樣式 or 圖表的外觀樣式
//                    AreaMark(
//                        x: .value("Time", index),
//                        yStart: .value("Min", data.yAxisData.axisStart),
//                        yEnd: .value("Max", 100)
//                    )
                }
            }
//            .chartXAxisLabel("Date (2023)", alignment: .leading)
//                        .chartYAxisLabel("Price (NTD)", alignment: .trailing)
//                        .frame(height: 300)
//                        .padding()
//                        .chartXAxis {
//                            AxisMarks(values: .stride(by: .month)) { value in
//                                AxisGridLine()
//                                AxisValueLabel(format: .dateTime.month(.defaultDigits))
//                            }
//                        }
            .chartXAxisLabel("Date (2023)", alignment: .leading)
            .chartYAxisLabel("Price (NTD)", alignment: .trailing)
            .frame(height: 300)
            .padding()
        }
    }
}

struct LineMarkCharts_Previews: PreviewProvider {
    static var previews: some View {
        LineMarkCharts()
    }
}

// #Preview {
//    LineMarkCharts()
// }
//class StockEntityViewModel: ObservableObject {
//    let saveData = SaveData.shared
//    var stockData: [TransactionForChart] = [
//        // MARK: TSMC Stock Price
//
////        .init(year: "2023",
////              mon: 2,
////              amount: 400,
////              currency: "新台幣",
////              date: Date(), 
////              from: "",
////              note: "",
////              payUser: [:],
////              shareUser: [:],
////              subType: TransactionType(iconName: "food-icon", name: "food"),
////              transactionType: TransactionType(iconName: "", name: "expenses")),
////        .init(year: "2023",
////              mon: 2,
////              amount: 400,
////              currency: "新台幣",
////              date: Date(),
////              from: "",
////              note: "",
////              payUser: [:],
////              shareUser: [:],
////              subType: TransactionType(iconName: "food-icon", name: "food"),
////              transactionType: TransactionType(iconName: "", name: "expenses")),
////        .init(year: "2023",
////              mon: 2,
////              amount: 400,
////              currency: "新台幣",
////              date: Date(),
////              from: "",
////              note: "",
////              payUser: [:],
////              shareUser: [:],
////              subType: TransactionType(iconName: "food-icon", name: "food"),
////              transactionType: TransactionType(iconName: "", name: "expenses")),
//    ]
//
//    init() {
//        stockData = SaveData.shared.transactionsArray
//    }
//
////    let saveData = SaveData.shared
////
////       // 使用 Double 類型的數據來初始化 PieChart 的 data
////       @Published var pieChartData: [Double] = []
////
////       // 使用 String 類型的數據來初始化 PieChart 的 labels
////       @Published var pieChartLabels: [String] = []
////
////       var stockData: [Test] = [] {
////           didSet {
////               updatePieChartData()
////           }
////       }
////
////       init() {
////           self.stockData = SaveData.shared.transactionsArray
////       }
////
////       private func updatePieChartData() {
////           pieChartData = stockData.map { $0.amount }
////           pieChartLabels = stockData.map { $0.type.name}
////       }
//}
