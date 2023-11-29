//
//  RealData.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/19.
//

import Foundation

class SaveData {
    static let shared = SaveData()

    var accountData: TransactionsResponse? {
        didSet {
            if let accountData = accountData {
                getAccountArray(transactionsResponse: accountData)
            }
        }
    }

    var userInfoData: [String: UsersInfoResponse] = [:]
    var myInfo: UsersInfoResponse?
    var myShareAccount: [String: String] = [:]
    var transactionsArray: [Test] = []
//    var accountInfo:

    func getAccountArray(transactionsResponse _: TransactionsResponse) -> [Test] {
        transactionsArray = []
        guard let transactions = accountData?.transactions else { return [] }
        for monKey in transactions.keys {
            guard let monTransactions = transactions[monKey] else { return [] }
            for dayKey in monTransactions.keys {
                guard let dayTransactions = monTransactions[dayKey] else { return [] }
                for timeKey in dayTransactions.keys {
                    guard let timeTransactions = dayTransactions[timeKey] else { return [] }

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
                                                  type: timeTransactions.type))
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
    var type: TransactionType
}
