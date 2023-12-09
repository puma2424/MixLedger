//
//  FirebaseRespone.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/3.
//

import Foundation
struct TransactionsResponse: Codable {
    var transactions: [String: [String: [String: Transaction]]]?
    var accountID: String
    var accountInfo: AccountInfo
    var accountName: String
    var shareUsersID: [[String: Double]]?
    var iconName: String?
}

struct AccountInfo: Codable {
    var budget: Double
    var expense: Double
    var income: Double
    var total: Double
}

struct Transaction: Codable {
    var transactionType: TransactionType?
    var amount: Double
    var currency: String
    var date: Date
    var from: String?
    var note: String
    var payUser: [String: Double]?
    var shareUser: [String: Double]?
    var subType: TransactionType

//    init(amount: Double, currency: String, date: Date, from: String?, note: String?, payUser: [String: Double]?, shareUser: [String: Double]?, type: TransactionType, year _: String) {
//        let dateFont = DateFormatter()
//        dateFont.dateFormat = "yyyy"
//        let dateString = dateFont.string(from: date)
////        self.id = id
//        self.amount = amount
//        self.currency = currency
//        self.date = date
//        self.from = from
//        self.note = note
//        self.payUser = payUser
//        self.shareUser = shareUser
//        self.type = type
//        year = dateString
//    }
}

enum TransactionMainType{
    case expenses
    case income
    case transfer
    
    var text: String{
        switch self{
        case .expenses:
            "expenses"
        case .income:
            "income"
        case .transfer:
            "transfer"
        }
    }
    
    init?(text: String) {
            switch text.lowercased() {
            case "expenses":
                self = .expenses
            case "income":
                self = .income
            case "transfer":
                self = .transfer
            default:
                return nil
            }
        }
    
}

struct TransactionType: Codable {
    var iconName: String
    var name: String
}

struct UsersInfoResponse: Codable {
    var name: String
    var ownAccount: String
    var shareAccount: [String]
    var userID: String
    var inviteCard: [InviteCard]?
    var message: [Message]?
}

struct Message: Codable{
    var toSenderMessage: String
    var toReceiverMessage: String
    var fromUserID: String
    var isDunningLetter: Bool
    var amount: Double
    var toUserID: String
    var formAccoundID: String
    var fromAccoundName: String
}

struct InviteCard: Codable {
    var inviterID: String
    var accountID: String
    var accountName: String
    var inviterName: String
}
