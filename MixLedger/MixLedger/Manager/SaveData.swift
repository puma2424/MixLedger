//
//  RealData.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/19.
//

import Foundation

struct MyShareAccountInfo {
    var name: String
    var id: String
    var iconName: String
}

struct ChartData: Identifiable {
    var id = UUID().uuidString
    var year: String
    var mon: Int
    var amount: Double
    var currency: String
    var date: Date
    var from: String?
    var note: String?
    var payUser: [String: Double]?
    var shareUser: [String: Double]?
    var subType: TransactionType
    var transactionType: TransactionType
}

//manager
class SaveData {
    static let shared = SaveData()

    var accountData: TransactionsResponse?
    
//    var myID = ""
    var myID = "bGzuwR00sPRNmBamK91D" // test
    
    var userInfoData: [UsersInfoResponse] = []
    var myInfo: UsersInfoResponse? {
        didSet {
            // 在發布者處發送通知
            NotificationCenter.default.post(name: .myMessageNotification, object: nil)
            NotificationCenter.default.post(name: .myAccountNotification, object: nil)
        }
    }

    var myShareAccount: [String: MyShareAccountInfo] = [:]

    static func getAccountArrayForCharts() -> [ChartData] {
        let transactions = self.shared.getTransactionArray()
        
        var transactionsArray: [ChartData] = transactions.compactMap { transaction in
            guard let transactionType = TransactionMainType(text: transaction.transactionType.name),
                      transaction.amount != 0,
                      transactionType == .expenses else {
                    return nil
                }

                let dateFont = DateFormatter()
                dateFont.dateFormat = "yyyy"
                let dateString = dateFont.string(from: transaction.date)
                let calendar = Calendar.current
                let monthNumber = calendar.component(.month, from: transaction.date)

                return ChartData(
                    year: dateString,
                    mon: monthNumber,
                    amount: abs(transaction.amount),
                    currency: transaction.currency,
                    date: transaction.date,
                    subType: transaction.subType,
                    transactionType: TransactionType(iconName: "", name: transactionType.text)
                )
        }
        return transactionsArray
    }
    
   private func getTransactionArray() -> [Transaction] {
        guard let transactions = accountData?.transactions else { return [] }
        let originalTransactions = transactions.flatMap { _, monValue in
            monValue
        }.flatMap { _, dayValue in
            dayValue
        }.flatMap { _, timeValue in
            timeValue
        }
        return originalTransactions
    }
}

