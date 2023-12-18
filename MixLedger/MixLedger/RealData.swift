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

class SaveData {
    static let shared = SaveData()

    var accountData: TransactionsResponse? {
        didSet {
            if let accountData = accountData {
                getAccountArrayForCharts(transactionsResponse: accountData)
            }
        }
    }

    var myUId: String = ""

//    var myID = ""
    var myID = "bGzuwR00sPRNmBamK91D" // trst
//    var myID = "qmgOOutGItrZyzKqQOrh"  //porter
    var userInfoData: [UsersInfoResponse] = []
    var myInfo: UsersInfoResponse? {
        didSet {
            // 在發布者處發送通知
            NotificationCenter.default.post(name: .myMessageNotification, object: nil)
            NotificationCenter.default.post(name: .myAccountNotification, object: nil)
        }
    }

    var myShareAccount: [String: MyShareAccountInfo] = [:]
    var transactionsArray: [Test] = []
//    var accountInfo:

    func getAccountArrayForCharts(transactionsResponse _: TransactionsResponse) -> [Test] {
        transactionsArray.removeAll()
        guard let transactions = accountData?.transactions else { return [] }
        for monKey in transactions.keys {
            guard let monTransactions = transactions[monKey] else { return [] }
            for dayKey in monTransactions.keys {
                guard let dayTransactions = monTransactions[dayKey] else { return [] }
                for timeKey in dayTransactions.keys {
                    guard let timeTransactions = dayTransactions[timeKey] else { return [] }
                    if let typeName = timeTransactions.transactionType?.name,
                       let transactionType = TransactionMainType(text: "\(typeName)"),
                       timeTransactions.amount != 0
                    {
                        if transactionType == .expenses {
                            let dateFont = DateFormatter()
                            dateFont.dateFormat = "yyyy"
                            let dateString = dateFont.string(from: timeTransactions.date)
                            let calendar = Calendar.current
                            let monthNumber = calendar.component(.month, from: timeTransactions.date)
                            transactionsArray.append(Test(year: dateString,
                                                          mon: monthNumber,
                                                          amount: abs(timeTransactions.amount),
                                                          currency: timeTransactions.currency,
                                                          date: timeTransactions.date,
                                                          subType: timeTransactions.subType,
                                                          transactionType: TransactionType(iconName: "", name: transactionType.text)))
                        }
                    }
                }
            }
        }

        print(transactionsArray)
        return transactionsArray
    }
}

struct Test: Identifiable {
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
