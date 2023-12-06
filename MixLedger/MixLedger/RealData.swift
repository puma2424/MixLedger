//
//  RealData.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/19.
//

import Foundation

class SaveData {
    static let shared = SaveData()

    var accountData: TransactionsResponse?{
        didSet{
            if let accountData = accountData{
                self.getAccountArrayForCharts(transactionsResponse: accountData)
            }
        }
    }
    
    var myUId: String = ""
    
    var myID = ""
//     var myID = "bGzuwR00sPRNmBamK91D" //trst
//    var myID = "qmgOOutGItrZyzKqQOrh"  //porter
    var userInfoData: [UsersInfoResponse] = []
    var myInfo: UsersInfoResponse?{
        didSet{
            // 在發布者處發送通知
            NotificationCenter.default.post(name: .myMessageNotification, object: nil)
        }
    }
    var myShareAccount: [String: String] = [:]
    var transactionsArray: [Test] = []
//    var accountInfo:
    
    
    func getAccountArrayForCharts(transactionsResponse: TransactionsResponse) -> [Test]{
        transactionsArray = []
        guard let transactions = accountData?.transactions else { return [] }
        for monKey in transactions.keys {
            guard let monTransactions = transactions[monKey] else { return [] }
            for dayKey in monTransactions.keys {
                guard let dayTransactions = monTransactions[dayKey] else { return [] }
                for timeKey in dayTransactions.keys {
                    guard let timeTransactions = dayTransactions[timeKey] else { return [] }
                    if let transactionType = TransactionMainType(text: "\(timeTransactions.transactionType.name)") {
                        if transactionType == .expenses{
                            let dateFont = DateFormatter()
                            dateFont.dateFormat = "yyyy"
                            let dateString = dateFont.string(from: timeTransactions.date)
                            let calendar = Calendar.current
                            let monthNumber = calendar.component(.month, from: timeTransactions.date)
                            transactionsArray.append(Test(year: dateString,
                                                          mon: monthNumber,
                                                          amount: timeTransactions.amount,
                                                          currency: timeTransactions.currency,
                                                          date: timeTransactions.date,
                                                          subType: timeTransactions.subType,
                                                          transactionType: timeTransactions.transactionType))
                        }
                    }
                    
                }
            }
        }
        if transactionsArray.count == 0{
            let dateFont = DateFormatter()
            dateFont.dateFormat = "yyyy"
            let dateString = dateFont.string(from: Date())
            let calendar = Calendar.current
            let monthNumber = calendar.component(.month, from: Date())
            let transactionMainType: TransactionMainType = TransactionMainType.expenses
            
            transactionsArray.append(Test(year: dateString,
                                          mon: monthNumber,
                                          amount: 0,
                                          currency: "新台幣",
                                          date: Date(),
                                          subType: TransactionType(iconName: "", name: ""),
                                          transactionType: TransactionType(iconName: "", name: transactionMainType.text)))
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
