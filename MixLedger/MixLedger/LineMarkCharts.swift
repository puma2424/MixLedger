//
//  LineMarkCharts.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/27.
//

import SwiftUI
import Charts

struct LineMarkCharts: View {
    @State private var saveData = SaveData.shared
//    @State private var transactionsArray: [Transaction] = SaveData.shared.transactionsArray
//    @EnvironmentObject var saveData: SaveData
//    @EnvironmentObject private var transactionsArray: [Transaction]
    @State private var vm = StockEntityViewModel()
    var body: some View {
        VStack {
            Chart{
                
//                ForEach(saveData.transactionsArray) { data in
//                    LineMark(
//                        x: .value("Date", data.date),
//                        y: .value("amount", data.amount)
//                    )
//                    .foregroundStyle(by: .value("Stock Name", data.year!)) // 4：左下角的圖例樣式 or 圖表的外觀樣式
//                    .symbolSize(100)
//                }
                
                ForEach(vm.stockData) { data in
                    LineMark(
                        x: .value("Date", data.mon),
                        y: .value("amount", data.amount)
                    ).foregroundStyle(by: .value("Stock Name", data.year)) // 4：左下角的圖例樣式 or 圖表的外觀樣式
//                    AreaMark(
//                        x: .value("Time", index),
//                        yStart: .value("Min", data.yAxisData.axisStart),
//                        yEnd: .value("Max", 100)
//                    )
                    
                }
            }
            .chartXAxisLabel("Date (2022/8/19~2022/9/8)", alignment: .leading)
                        .chartYAxisLabel("Price (NTD)", alignment: .trailing)
                        .frame(height: 300)
                        .padding()
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .month)) { value in
                                AxisGridLine()
                                AxisValueLabel(format: .dateTime.month(.defaultDigits))
                            }
                        }
        }
        
        
    }
    
    
}

struct LineMarkCharts_Previews: PreviewProvider {
    static var previews: some View {
        LineMarkCharts()
    }
}
//#Preview {
//    LineMarkCharts()
//}
class StockEntityViewModel {
//    var stockData: [test]
    let saveData = SaveData.shared
//    func test(){
//        if let data = saveData.accountData {
//            for xxxin in saveData.accountData{
//                tt = xxxin.
//            }
//        }
//        
//    }
    var stockData: [Test] = [
        
        // MARK: TSMC Stock Price
        .init(year: "2023", mon: 2, amount: 400, currency: "新台幣", date: Date(), from: "", note: "", payUser: [:], shareUser: [:], type: TransactionType()),
        .init(year: "2023", mon: 2, amount: 400, currency: "新台幣", date: Date(), from: "", note: "", payUser: [:], shareUser: [:], type: TransactionType()),
    ]
//    var stockData: [Transaction] = SaveData.shared.transactionsArray
    init() {
            self.stockData = SaveData.shared.transactionsArray
        }
}
