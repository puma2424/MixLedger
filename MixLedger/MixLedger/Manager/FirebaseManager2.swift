//
//  FirebaseManager2.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/4.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

extension FirebaseManager {
    // MARK: - 新增帳號

    func postNewOwnAccount(uid: String, accountNAme: String, completion: @escaping (Result<String, Error>) -> Void) {
        let newAccount = db.collection("account").document()
//        guard let myInfo = self.saveData.myInfo else { return }
        let sharesID = [[uid: 0.0]]
        let accountInfo = AccountInfo(budget: 0, expense: 0, income: 0, total: 0)
        let newAccountInfo = TransactionsResponse(accountID: newAccount.documentID, accountInfo: accountInfo, accountName: accountNAme, shareUsersID: sharesID, iconName: "storytelling")

        do {
            try db.collection("accounts").document(newAccount.documentID).setData(from: newAccountInfo) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    self.db.collection("users").document(uid).updateData([
                        "ownAccount": FieldValue.arrayUnion([newAccount.documentID]),
                    ])
                    print("Document successfully written!")
                    completion(.success(newAccount.documentID))
                }
            }
        } catch {
            print("Error writing city to Firestore: \(error)")
            completion(.failure(error))
        }
    }

    static func postNewUser(uid: String, email _: String, newUser: UsersInfoResponse, accountNAme: String, completion: @escaping (Result<String, Error>) -> Void) {
        shared.postNewOwnAccount(uid: uid, accountNAme: accountNAme) { result in
            switch result {
            case let .success(newAccountID):
                do {
                    var user = newUser
                    user.ownAccount = newAccountID
                    try self.shared.db.collection("users").document(uid).setData(from: user) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                            print(err)
                            completion(.failure(err))
                        } else {
                            completion(.success("成功建立新帳戶"))
                        }
                    }
                } catch {
                    print("Error writing city to Firestore: \(error)")
                    completion(.failure(error))
                }
            case let .failure(err):
                print(err)
                completion(.failure(err))
            }
        }
    }

    func findAccount(account: [String], completion: @escaping (Result<Any, Error>) -> Void) {
        print("-------account array---------")
        print(account)

        let docRef = db.collection("accounts")
        if !account.isEmpty {
            docRef.whereField("accountID", in: account).getDocuments { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let querySnapshot = querySnapshot {
                        for document in querySnapshot.documents {
                            //                print("\(document.documentID) => \(document.data())")
                            print(document.data()["accountName"])
                            if let id = document.data()["accountID"] as? String,
                               let name = document.data()["accountName"] as? String,
                               let iconName = document.data()["iconName"] as? String
                            {
                                self.saveData.myShareAccount[id] = MyShareAccountInfo(name: name, id: id, iconName: iconName)

                            } else {
                                let id = document.data()["accountID"] as? String
                                print(id)
                                print(document.data()["accountID"])
                                print(document.data()["accountName"])
                            }
                        }
                    }
                    completion(.success("success"))
                }
                print(self.saveData.myShareAccount)
            }
        }
    }

    static func postDeleteInvitation(accountID: String, accountName: String, inviterID: String, inviterName: String, completion: @escaping (Result<String, Error>) -> Void) {
        let myID = SaveData.shared.myID

        shared.db.collection("users").document(myID).updateData([
            "inviteCard": FieldValue.arrayRemove([["accountID": accountID,
                                                   "inviterID": inviterID,
                                                   "inviterName": inviterName,
                                                   "accountName": accountName]]),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                completion(.failure(err))
            } else {
                print("Document successfully updated postAgareShareAccount")
                completion(.success("成功刪除邀請卡"))
            }
        }
    }

    static func postDeleteMessage(userID: String, messageInfo: Message, completion: @escaping (Result<String, Error>) -> Void) {
        shared.db.collection("users").document(userID).updateData([
            "message": FieldValue.arrayRemove([["toSenderMessage": messageInfo.toSenderMessage,
                                                "toReceiverMessage": messageInfo.toReceiverMessage,
                                                "fromUserID": messageInfo.fromUserID,
                                                "toUserID": messageInfo.toUserID,
                                                "isDunningLetter": messageInfo.isDunningLetter,
                                                "amount": messageInfo.amount,
                                                "formAccoundID": messageInfo.formAccoundID,
                                                "fromAccoundName": messageInfo.fromAccoundName]]),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                completion(.failure(err))
            } else {
                print("Document successfully updated postAgareShareAccount")
                completion(.success("成功刪除訊息"))
            }
        }
    }

    static func postLeaveAccout(userID: String, accountId: String, completion: @escaping (Result<String, Error>) -> Void) {
        shared.db.collection("users").document(userID).updateData([
            "shareAccount": FieldValue.arrayRemove([accountId]),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                completion(.failure(err))
            } else {
                print("Document successfully updated postAgareShareAccount")
                completion(.success("成功離開帳本"))
            }
        }
    }

    static func postUpdataUserInfo(iconName: String?, name: String?, completion: @escaping (Result<String, Error>) -> Void) {
        let batch = shared.db.batch()

        if let iconName = iconName {
            let updataIcon = shared.db.collection("users").document(SaveData.shared.myID)
            batch.updateData(["iconName": iconName], forDocument: updataIcon)
        }

        if let name = name {
            let updataIcon = shared.db.collection("users").document(SaveData.shared.myID)
            batch.updateData(["name": name], forDocument: updataIcon)
        }

        batch.commit { err in
            if let err = err {
                print("Error committing batch: \(err)")
                completion(.failure(err))
            } else {
                print("Batch committed successfully.")
                completion(.success("成功更新"))
            }
        }
    }
    
    func removeAccountListener() {
        if accountListener != nil {
            accountListener?.remove()
        }
    }

    func addAccountListener(accountID: String, completion: @escaping (Result<TransactionsResponse, Error>) -> Void) {
        // 從 Firebase 獲取數據
        let docRef = db.collection("accounts").document(accountID)

        removeAccountListener()

        accountListener = docRef.addSnapshotListener { document, error in
            if let error = error as NSError? {
                self.errorMessage = "Error getting document: \(error.localizedDescription)"
            } else {
                if let document = document {
                    do {
                        print("-----get account undecode Data------")
                        print(document.data())
                        let accountData = try document.data(as: TransactionsResponse.self)
                        print("-----get account decode Data------")
                        self.saveData.accountData = accountData
                        print("\(self.saveData.accountData?.accountName)")
                        completion(.success(accountData))
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func getUsreInfo(userID: [String], completion: @escaping (Result<[UsersInfoResponse], Error>) -> Void) {
        if !userID.isEmpty {
            var responData: [UsersInfoResponse] = []

            db.collection("users").whereField("userID", in: userID).getDocuments { querySnapshot, err in
                do {
                    if let err = err {
                        print("Error getting documents: \(err)")
                        throw err
                    } else {
                        for document in querySnapshot!.documents {
                            let responseData = try document.data(as: UsersInfoResponse.self)
                            responData.append(responseData)
                        }
                        completion(.success(responData))
                    }
                } catch {
                    print(error)
                }
            }
        }
        print("\(saveData.userInfoData)")
    }

    
    func removeUserMessageListener() {
        userMessageListener?.remove()
    }

    func addUserListener(userID: String, completion: @escaping (Result<UsersInfoResponse, Error>) -> Void) {
        removeUserMessageListener()

        if !userID.isEmpty {
            let docRef = db.collection("users").document(userID)

            userMessageListener = docRef.addSnapshotListener { document, error in
                if let error = error as NSError? {
                    self.errorMessage = "Error getting document: \(error.localizedDescription)"
                    completion(.failure(error))
                } else {
                    if let document = document {
                        print("-----find User------")
                        print(document.data())
                        do {
                            let responseData = try document.data(as: UsersInfoResponse.self)
                            print(responseData)
                            completion(.success(responseData))
                        } catch {
                            print(error)
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
        print("\(saveData.userInfoData)")
    }
}




//    func confirmPayment(messageInfo: Message, textToOtherUser _: String, textToMyself _: String, completion: @escaping (Result<String, Error>) -> Void) {
//        guard let accountID = saveData.myInfo?.ownAccount else { return }
//        var othetUserAccountID = ""
//        getUsreInfo(userID: [messageInfo.fromUserID]) { result in
//            switch result {
//            case let .success(data):
//                othetUserAccountID = data[0].ownAccount
//                guard let myInfo = self.saveData.myInfo else { return /* completion(.failure(_)) */ }
//                print(othetUserAccountID)
//
//                let postTransactionToExpenses = Transaction(
//                    transactionType: TransactionType(iconName: "", name: TransactionMainType.expenses.text),
//                    amount: -messageInfo.amount,
//                    currency: "新台幣", date: Date(),
//                    from: messageInfo.fromAccoundName,
//                    note: "",
//                    subType: TransactionType(iconName: AllIcons.cashInHand.rawValue, name: "付款"))
//
//                let postTransactionToShare = Transaction(transactionType: TransactionType(iconName: "", name: TransactionMainType.income.text),
//                                                         amount: messageInfo.amount,
//                                                         currency: "新台幣",
//                                                         date: Date(),
//                                                         from: messageInfo.fromAccoundName,
//                                                         note: "",
//                                                         subType: TransactionType(iconName: AllIcons.cashInHand.rawValue, name: "收支平衡"))
//
//                let postTransactionToIncome = Transaction(transactionType: TransactionType(iconName: "", name: TransactionMainType.income.text),
//                                                          amount: messageInfo.amount,
//                                                          currency: "新台幣",
//                                                          date: Date(),
//                                                          from: messageInfo.fromAccoundName,
//                                                          note: "",
//                                                          subType: TransactionType(iconName: AllIcons.cashInHand.rawValue, name: "收款"))
//
//                // value：同時間最多有1個thread可以存取某資源
//                var semaphore = DispatchSemaphore(value: 1)
//                let queue = DispatchQueue(label: "myqueue")
//
//                queue.async {
//                    semaphore.wait() // thread正在工作
//                    self.postIncome(toAccountID: myInfo.ownAccount, transaction: postTransactionToIncome, memberPayMoney: [:], memberShareMoney: [:]) { result in
//                        switch result {
//                        case .success:
//                            semaphore.signal() // thread結束工作，可以進行下一個
//                            return
//                        case .failure:
//                            return
//                        }
//                    }
//                }
//
//                queue.async {
//                    semaphore.wait()
//                    // thread正在工作
//                    self.postData(toAccountID: othetUserAccountID, transaction: postTransactionToExpenses, memberPayMoney: [:], memberShareMoney: [:]) { result in
//                        switch result {
//                        case .success:
//                            semaphore.signal() // thread結束工作，可以進行下一個
//                        case .failure:
//                            return
//                        }
//                    }
//                }
//
//                queue.async {
//                    semaphore.wait() // thread正在工作
//                    self.postIncome(toAccountID: messageInfo.formAccoundID,
//                                    transaction: postTransactionToShare,
//                                    memberPayMoney: [messageInfo.fromUserID: messageInfo.amount, messageInfo.toUserID: 0.0],
//                                    memberShareMoney: [messageInfo.toUserID: messageInfo.amount, messageInfo.fromUserID: 0.0])
//                    { result in
//                        switch result {
//                        case .success:
//                            print("qqqqqq===")
//                            semaphore.signal() // thread結束工作，可以進行下一個
//                        case let .failure(err):
//                            print(err)
//                            print("xxxxxxx===")
//                        }
//                    }
//                }
//
//                queue.async {
//                    semaphore.wait() // thread正在工作
//                    self.db.collection("users").document(messageInfo.toUserID).updateData([
//                        "message": FieldValue.arrayRemove([["toSenderMessage": messageInfo.toSenderMessage,
//                                                            "toReceiverMessage": messageInfo.toReceiverMessage,
//                                                            "fromUserID": messageInfo.fromUserID,
//                                                            "toUserID": messageInfo.toUserID,
//                                                            "isDunningLetter": messageInfo.isDunningLetter,
//                                                            "amount": messageInfo.amount,
//                                                            "formAccoundID": messageInfo.formAccoundID,
//                                                            "fromAccoundName": messageInfo.fromAccoundName]]),
//                    ]) { err in
//                        if let err = err {
//                            print("Error updating document: \(err)")
//                            completion(.failure(err))
//                        } else {
//                            print("Document successfully updated postAgareShareAccount")
//                            completion(.success("成功變動使用者擁有帳本資訊"))
//                            semaphore.signal() // thread結束工作，可以進行下一個
//                        }
//                    }
//                }
//
//            case .failure:
//                return
//            }
//        }
//    }
