//
//  fake data.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import Foundation
import UIKit

struct BillTag {
    var iconName: String
    var name: String
}

// var myID = "bGzuwR00sPRNmBamK91D" //puma
// var myID = "qmgOOutGItrZyzKqQOrh" // porter
var billArray: [[String: [Any]]] = [["日期": [Date()],
                                     "item": [["金額": -3_000_000,
                                               "付費者": ["puma", "niw"],
                                               "分費者": ["puma"],
                                               "備註": "草莓欸",
                                               "幣別": "新台幣",
                                               "類型": BillTag(iconName: "more", name: "飲食"),
                                               "照片": UIImage(named: "more"),
                                               "from": ""],
                                              ["金額": -300,
                                               "付費者": ["puma", "niw"],
                                               "分費者": ["puma"],
                                               "備註": "草莓好好吃誒誒誒誒誒誒誒誒誒誒欸誒誒誒誒誒誒誒誒誒",
                                               "幣別": "新台幣",
                                               "類型": BillTag(iconName: "more", name: "飲食"),
                                               "照片": UIImage(named: "more"),
                                               "from": ""]]],
                                    ["日期": [Date()],
                                     "item": [["金額": 3_000_000,
                                               "付費者": ["puma", "niw"],
                                               "分費者": ["puma"],
                                               "備註": "草莓欸",
                                               "幣別": "新台幣",
                                               "類型": BillTag(iconName: "more", name: "飲食"),
                                               "照片": UIImage(named: "more"),
                                               "from": ""],
                                              ["金額": 300,
                                               "付費者": ["puma", "niw"],
                                               "分費者": ["puma"],
                                               "備註": "草莓好好吃誒誒誒誒誒誒誒誒誒誒欸誒誒誒誒誒誒誒誒誒",
                                               "幣別": "新台幣",
                                               "類型": BillTag(iconName: "more", name: "飲食"),
                                               "照片": UIImage(named: "more"),
                                               "from": ""]]]]

var allAccount: [[String: Any]] = [["name": "我的帳本",
                                    "iconName": AllIcons.bookAndPencil.rawValue],
                                   ["name": "嘉義好好玩",
                                    "iconName": AllIcons.human.rawValue]]

// func confirmPayment(messageInfo: Message, textToOtherUser: String, textToMyself: String, completion: @escaping (Result<String,Error>) -> Void) {
//    guard let accountID = saveData.myInfo?.ownAccount else {return}
//    var othetUserAccountID: String = ""
//    getUsreInfo(userID: [messageInfo.fromUserID]){result in
//        switch result{
//        case .success(let data):
//            othetUserAccountID = data[0].ownAccount
//            guard let myInfo = self.saveData.myInfo else{return/*completion(.failure(_))*/}
//            print(othetUserAccountID)
//
//            let postTransactionToExpenses = Transaction(transactionType: TransactionType(iconName: "", name: TransactionMainType.expenses.text),
//                                                        amount: -messageInfo.amount,
//                                                        currency: "新台幣", date: Date(),
//                                                        from: messageInfo.fromAccoundName,
//                                                        note: "",
//                                                        subType: TransactionType(iconName: "", name: "付款"))
//
//            let postTransactionToShare = Transaction(transactionType: TransactionType(iconName: "", name: TransactionMainType.income.text),
//                                                     amount: messageInfo.amount,
//                                                     currency: "新台幣",
//                                                     date: Date(),
//                                                     from: messageInfo.fromAccoundName,
//                                                     note: "",
//                                                     subType: TransactionType(iconName: "", name: "收支平衡"))
//
//            let postTransactionToIncome = Transaction(transactionType: TransactionType(iconName: "", name: TransactionMainType.income.text),
//                                                     amount: messageInfo.amount,
//                                                     currency: "新台幣",
//                                                     date: Date(),
//                                                     from: messageInfo.fromAccoundName,
//                                                     note: "",
//                                                     subType: TransactionType(iconName: "", name: "收款"))
//
//            // 發送訊息
//            // 自己的帳本增加收入款項
//            self.postIncome(toAccountID: myInfo.ownAccount, transaction: postTransactionToIncome, memberPayMoney: [:], memberShareMoney: [:]){ result in
//                switch result{
//                case .success(_):
//                    // 對方的帳本扣款
//                    self.postData(toAccountID: othetUserAccountID, transaction: postTransactionToExpenses, memberPayMoney: [:], memberShareMoney: [:]){ result in
//                        switch result{
//                        case .success(_):
//
//                            self.db.collection("users").document(messageInfo.toUserID).updateData([
//                                "message": FieldValue.arrayRemove([["toSenderMessage": messageInfo.toSenderMessage,
//                                                                    "toReceiverMessage": messageInfo.toReceiverMessage,
//                                                                    "fromUserID" : messageInfo.fromUserID,
//                                                                    "toUserID": messageInfo.toUserID,
//                                                                    "isDunningLetter": messageInfo.isDunningLetter,
//                                                                    "amount": messageInfo.amount,
//                                                                    "formAccoundID": messageInfo.formAccoundID,
//                                                                    "fromAccoundName": messageInfo.fromAccoundName]]),
//                            ]) { err in
//                                if let err = err {
//                                    print("Error updating document: \(err)")
//                                    completion(.failure(err))
//                                } else {
//                                    print("Document successfully updated postAgareShareAccount")
//                                    completion(.success("成功變動使用者擁有帳本資訊"))
//                                }
//                            }
//
//
//                            self.postIncome(toAccountID: messageInfo.formAccoundID,
//                                            transaction: postTransactionToShare,
//                                            memberPayMoney: [messageInfo.fromUserID : messageInfo.amount, messageInfo.toUserID : 0.0],
//                                            memberShareMoney: [messageInfo.toUserID : messageInfo.amount, messageInfo.fromUserID : 0.0]){ result  in
//                                switch result{
//                                case .success(_):
//                                    print("qqqqqq===")
//                                case .failure(let err):
//                                    print(err)
//                                    print("xxxxxxx===")
//                                }
//                                return}
//
//                        case .failure(_):
//                            return
//                        }
//                    }
//                    return
//                case .failure(_):
//                    return
//                }
//
//            }
//        case .failure(_):
//            return
//        }
//    }
// }
