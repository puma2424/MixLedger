//
//  LineMarkCharts.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/27.
//

import SwiftUI
import Charts

struct LLLLLineMarkCharts: View {
    @State private var saveData = SaveData.shared.transactionsArray
    @State private var transactionsArray: [Transaction] = []
    
    var body: some View {
        VStack {
            Chart{
                ForEach(saveData) { data in
                    LineMark(
                        x: .value("Date", data.date),
                        y: .value("amount", data.amount)
                    )
                    .foregroundStyle(by: .value("Stock Name", data.year)) // 4：左下角的圖例樣式 or 圖表的外觀樣式
//                    .symbol(symbol) // 原本是直接給 .square，現在改成給 symbol 變數，讓 SwiftUI 自動更新變數狀態
                    .symbolSize(100)
                }
            }
        }
    }
    
//    func inputData(){
//        transactionsArray = saveData.transactionsArray
//        VStack {
//            Chart(saveData.transactionsArray) { data in
//                LineMark(
//                    x: .value("Date", data.date),
//                    y: .value("amount", data.amount)
//                )
//                .foregroundStyle(by: .value("Stock Name", data.year!)) // 4：左下角的圖例樣式 or 圖表的外觀樣式
//            }
//        }
//    }
}


//class LineMarkCharts: UIView {
//
//    /*
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//    }
//    */
//
//}
