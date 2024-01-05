//
//  FirebaseManager.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/18.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

class FirebaseManager {
    static let shared = FirebaseManager()

    let db = Firestore.firestore()

    let saveData = SaveData.shared

    @Published var errorMessage: String?

    let dateFont = DateFormatter()

    var accountListener: ListenerRegistration?

    var userMessageListener: ListenerRegistration?

    // MARK: - 發送訊息 -
    func postMessage(message: Message,
                     completion: @escaping (Result<String, Error>) -> Void) {
        let messageContent: [String: Any] = ["toSenderMessage": message.toSenderMessage,
                                      "toReceiverMessage": message.toReceiverMessage,
                                      "fromUserID": message.fromUserID,
                                      "toUserID": message.toUserID,
                                      "isDunningLetter": message.isDunningLetter,
                                      "amount": message.amount,
                                      "formAccoundID": message.formAccoundID,
                                      "fromAccoundName": message.fromAccoundName]

        db.collection("users").document(message.toUserID).updateData([
            "message": FieldValue.arrayUnion([messageContent])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                completion(.failure(err))
            } else {
                if let myInfo = self.saveData.myInfo {
                    self.db.collection("users").document(myInfo.userID).updateData([
                        "message": FieldValue.arrayUnion([messageContent])
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                            completion(.failure(err))
                        } else {
                            completion(.success("成功發送訊息"))
                        }
                    }
                }
            }
        }
    }

    // MARK: - 確認還款 -
    
    func confirmPayment(
        messageInfo: Message,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let accountID = saveData.myInfo?.ownAccount else {
            return
        }

        let group = DispatchGroup()
        var othetUserAccountID = ""
        getUsreInfo(userID: [messageInfo.fromUserID]) { result in
            switch result {
            case let .success(data):
                othetUserAccountID = data[0].ownAccount
                guard let myInfo = self.saveData.myInfo else { return /* completion(.failure(_)) */ }
                print(othetUserAccountID)

                let postTransactionToExpenses = Transaction(
                    transactionType: TransactionType(iconName: "", name: TransactionMainType.expenses.text),
                    amount: -messageInfo.amount,
                    currency: "新台幣", date: Date(),
                    from: messageInfo.fromAccoundName,
                    note: "",
                    subType: TransactionType(iconName: AllIcons.cashInHand.rawValue, name: "付款"))

                let postTransactionToShare = Transaction(transactionType: TransactionType(iconName: "", name: TransactionMainType.income.text),
                                                         amount: messageInfo.amount,
                                                         currency: "新台幣",
                                                         date: Date(),
                                                         from: messageInfo.fromAccoundName,
                                                         note: "",
                                                         subType: TransactionType(iconName: AllIcons.cashInHand.rawValue, name: "收支平衡"))

                let postTransactionToIncome = Transaction(transactionType: TransactionType(iconName: "", name: TransactionMainType.income.text),
                                                          amount: messageInfo.amount,
                                                          currency: "新台幣",
                                                          date: Date(),
                                                          from: messageInfo.fromAccoundName,
                                                          note: "",
                                                          subType: TransactionType(iconName: AllIcons.cashInHand.rawValue, name: "收款"))
// combine
                // value：同時間最多有1個thread可以存取某資源
                var semaphore = DispatchSemaphore(value: 1)
                let queue = DispatchQueue(label: "myqueue")

                queue.async {
                    semaphore.wait() // thread正在工作
                    self.postIncome(toAccountID: myInfo.ownAccount, transaction: postTransactionToIncome, memberPayMoney: [:], memberShareMoney: [:]) { result in
                        switch result {
                        case .success:
                            semaphore.signal() // thread結束工作，可以進行下一個
                            return
                        case .failure:
                            return
                        }
                    }
                }

                queue.async {
                    semaphore.wait()
                    // thread正在工作
                    self.postData(toAccountID: othetUserAccountID, transaction: postTransactionToExpenses, memberPayMoney: [:], memberShareMoney: [:]) { result in
                        switch result {
                        case .success:
                            semaphore.signal() // thread結束工作，可以進行下一個
                        case .failure:
                            return
                        }
                    }
                }

                queue.async {
                    semaphore.wait() // thread正在工作
                    self.postIncome(toAccountID: messageInfo.formAccoundID,
                                    transaction: postTransactionToShare,
                                    memberPayMoney: [messageInfo.fromUserID: messageInfo.amount, messageInfo.toUserID: 0.0],
                                    memberShareMoney: [messageInfo.toUserID: messageInfo.amount, messageInfo.fromUserID: 0.0])
                    { result in
                        switch result {
                        case .success:
                            print("qqqqqq===")
                            semaphore.signal() // thread結束工作，可以進行下一個
                        case let .failure(err):
                            print(err)
                            print("xxxxxxx===")
                        }
                    }
                }

                queue.async {
                    semaphore.wait() // thread正在工作
                    self.db.collection("users").document(messageInfo.toUserID).updateData([
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
                            completion(.success("成功變動使用者擁有帳本資訊"))
                            semaphore.signal() // thread結束工作，可以進行下一個
                        }
                    }
                }

            case .failure:
                return
            }
        }
    }

    // MARK: - 回覆共享帳簿的邀請 -

    // 回覆共享帳簿的邀請
    func postRespondToInvitation(respond: Bool, accountID: String, accountName: String, inviterID: String, inviterName: String, completion: @escaping (Result<String, Error>) -> Void) {
        if respond {
            postAgareShareAccount(accountID: accountID, accountName: accountName, inviterID: inviterID, inviterName: inviterName) { result in
                switch result {
                case let .success(response):
                    print("\(response)---------")
                    completion(.success("成功加入帳本"))
                case let .failure(err):
                    print("---------\n postAgareShareAccount failure\n\(err)\n --------")
                    completion(.failure(err))
                }
            }
        } else {
            postAdjectShareAccount(accountID: accountID, accountName: accountName, inviterID: inviterID, inviterName: inviterName) { result in
                switch result {
                case let .success(response):
                    print("\(response)---------")
                    completion(.success("成功加入帳本"))
                case let .failure(err):
                    print("---------\n postAgareShareAccount failure\n\(err)\n --------")
                    completion(.failure(err))
                }
            }
        }
    }

    // 同意邀請
    private func postAgareShareAccount(accountID: String, accountName: String, inviterID: String, inviterName: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let myInfo = saveData.myInfo else { return }

        db.collection("accounts").document(accountID).updateData([
            "shareUsersID": FieldValue.arrayUnion([[myInfo.userID: 0.0]]),
            "invitees": FieldValue.arrayRemove([myInfo.userID]),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                completion(.failure(err))
            } else {
                completion(.success("成功變更帳本的共享者資訊"))
                print("Document successfully updated postAgareShareAccount")
                self.db.collection("users").document(self.saveData.myID).updateData([
                    "inviteCard": FieldValue.arrayRemove([["accountID": accountID,
                                                           "inviterID": inviterID,
                                                           "inviterName": inviterName,
                                                           "accountName": accountName]]),
                    "shareAccount": FieldValue.arrayUnion([accountID]),
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                        completion(.failure(err))
                    } else {
                        print("Document successfully updated postAgareShareAccount")
                        completion(.success("成功變動使用者擁有帳本資訊"))
                    }
                }
            }
        }
    }

    // 拒絕邀請
    private func postAdjectShareAccount(accountID: String, accountName: String, inviterID: String, inviterName: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let myID = saveData.myInfo?.userID else { return }
        db.collection("accounts").document(accountID).updateData([
            "invitees": FieldValue.arrayRemove([myID]),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                completion(.failure(err))
            } else {
                completion(.success("成功變更帳本的共享者資訊"))
                print("Document successfully updated postAgareShareAccount")
                self.db.collection("users").document(myID).updateData([
                    "inviteCard": FieldValue.arrayRemove([["accountID": accountID, "inviterID": inviterID, "inviterName": inviterName, "accountName": accountName]]),
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                        completion(.failure(err))
                    } else {
                        print("Document successfully updated postAgareShareAccount")
                        completion(.success("成功變動使用者擁有帳本資訊"))
                    }
                }
            }
        }
    }

    private func postShareAccountToInivitee(inviteeID: String, shareAccountID: String) {
        guard let myName = saveData.myInfo?.name else { return print("no myName") }
        guard let accountName = saveData.accountData?.accountName else { return print("no accountName") }
        db.collection("users").document(inviteeID).updateData([
            "inviteCard": FieldValue.arrayUnion([["accountID": shareAccountID, "inviterID": saveData.myInfo?.userID, "inviterName": myName, "accountName": accountName]]),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated postShareAccountToInivitee")
            }
        }
    }

    // MARK: - 發送共享帳簿的邀請 -

    // 發送共享帳簿的邀請
    func postShareAccountInivite(inviteeID: String, shareAccountID: String, shareAccountName _: String, inviterName _: String, completion: @escaping (Result<String, Error>) -> Void) {
        db.collection("accounts").document(shareAccountID).updateData([
            "invitees": FieldValue.arrayUnion([inviteeID]),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                completion(.failure(err))
            } else {
                print("Document successfully updated")
                self.postShareAccountToInivitee(inviteeID: inviteeID, shareAccountID: shareAccountID)
                completion(.success(""))
            }
        }
    }

    func getAllUser(completion: @escaping (Result<[UsersInfoResponse], Error>) -> Void) {
        db.collection("users").getDocuments { querySnapshot, err in
            var responeArray: [UsersInfoResponse] = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    do {
                        // print("----\n\(document.data())")
                        let data = try document.data(as: UsersInfoResponse.self)
                        responeArray.append(data)

                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                }
                completion(.success(responeArray))
            }
        }
    }

    // MARK: - 新增新帳本 -

    func addNewAccount(name: String, budget _: Double? = 0, iconName: String, completion: @escaping (Result<String, Error>) -> Void) {
        let newAccount = db.collection("account").document()
        guard let myInfo = saveData.myInfo else { return }
        let sharesID = [[myInfo.userID: 0.0]]
        let accountInfo = AccountInfo(budget: 0, expense: 0, income: 0, total: 0)
        let newAccountInfo = TransactionsResponse(accountID: newAccount.documentID, accountInfo: accountInfo, accountName: name, shareUsersID: sharesID, iconName: iconName)

        do {
            try db.collection("accounts").document(newAccount.documentID).setData(from: newAccountInfo) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                    completion(.failure(err))
                } else {
                    self.db.collection("users").document(myInfo.userID).updateData([
                        "shareAccount": FieldValue.arrayUnion([newAccount.documentID]),
                    ])
                    print("Document successfully written!")
                    completion(.success("success"))
                }
            }
        } catch {
            print("Error writing city to Firestore: \(error)")
            completion(.failure(error))
        }
    }
    
    func updateAccountMember(accountInfo: TransactionsResponse,
                             memberPayMoney: [String: Double],
                             memberShareMoney: [String: Double]) -> TransactionsResponse {
        var updatedAccountInfo = accountInfo

        for userID in memberPayMoney.keys {
            if let index = accountInfo.shareUsersID?.firstIndex(where: { $0.keys.contains(userID) }),
               var userDictionary = accountInfo.shareUsersID?[index] {
                guard let payMoney = memberPayMoney[userID],
                        let shareMoney = memberShareMoney[userID] else {
                    continue
                }
                
                userDictionary[userID] = (userDictionary[userID] ?? 0.0) - shareMoney + payMoney
                updatedAccountInfo.shareUsersID?[index] = userDictionary
            }
        }
        return updatedAccountInfo
    }

    func updateAccountIncome(
        withTransaction transaction: Transaction,
        memberPayMoney: [String: Double],
        memberShareMoney: [String: Double],
        inAccount accountInfo: TransactionsResponse,
        completion: @escaping (Result<Void, Error>) -> Void) {
         let updatedAccountInfo =   updateAccountMember(accountInfo: accountInfo, 
                                                        memberPayMoney: memberPayMoney,
                                                        memberShareMoney: memberShareMoney)
            
        let postTransaction: [String: Any] = [
            "amount": transaction.amount,
            "date": transaction.date,
            "payUser": memberPayMoney,
            "shareUser": memberShareMoney,
            "note": transaction.note,
            "transactionType": ["iconName": transaction.transactionType.iconName, "name": transaction.transactionType.name],
            "subType": ["iconName": transaction.subType.iconName, "name": transaction.subType.name],
            "currency": "新台幣",
            "from": transaction.from,
        ]

        dateFont.dateFormat = "yyyy-MM"
        let dateM = dateFont.string(from: transaction.date)
        dateFont.dateFormat = "yyyy-MM-dd"
        let dateD = dateFont.string(from: transaction.date)

        db.collection("accounts").document(accountInfo.accountID).updateData([
            "transactions.\(dateM).\(dateD).\(Date())": postTransaction,
            "shareUsersID": updatedAccountInfo.shareUsersID,
            "accountInfo.income": FieldValue.increment(transaction.amount),
            "accountInfo.total": FieldValue.increment(transaction.amount),
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
                completion(.failure(error))
            } else {
                print("Document successfully updated")
                completion(.success(()))
            }
        }
    }

    func postIncome(toAccountID: String,
                    transaction: Transaction,
                    memberPayMoney: [String: Double],
                    memberShareMoney: [String: Double],
                    completion: @escaping (Result<Void, Error>) -> Void) {
        getAccountData(accountID: toAccountID) { result in
            switch result {
            case let .success(accountData):
                print("----------accountData-----------")
                print(accountData)
                print("---------------------")
                self.updateAccountIncome(withTransaction: transaction, memberPayMoney: memberPayMoney, memberShareMoney: memberShareMoney, inAccount: accountData) { result in
                    switch result {
                    case let .success(str):
                        completion(.success(()))
                        print("----------success-----------")
                        print(str)
                        print("-----------------")
                    case let .failure(err):
                        completion(.failure(err))
                        print("-----------------")
                        print("failure")
                        return
                    }
                }
            case let .failure(err):
                completion(.failure(err))
                print("-----------------")
                print("failure")
                return
            }
        }
    }

    // MARK: - 記帳 -

    func post(toAccountID: String,
              transaction: Transaction,
              memberPayMoney: [String: Double],
              memberShareMoney: [String: Double],
              accountInfo: TransactionsResponse,
              completion: @escaping (Result<Any, Error>) -> Void) {
        
        let updatedAccountInfo =   updateAccountMember(accountInfo: accountInfo, memberPayMoney: memberPayMoney, memberShareMoney: memberShareMoney)
        
        let transactionMainType = TransactionMainType.expenses

        var postTransaction: [String: Any]?

//        if let transactionType = transaction.transactionType {
        let transactionType = transaction.transactionType 
            postTransaction = [
                "amount": transaction.amount,
                "date": transaction.date,
                "payUser": memberPayMoney,
                "shareUser": memberShareMoney,
                "note": transaction.note,
                "transactionType": ["iconName": transaction.transactionType.iconName, "name": transaction.transactionType.name],
                "subType": ["iconName": transaction.subType.iconName, "name": transaction.subType.name],
                "currency": "新台幣",
                "from": transaction.from,
            ]

            dateFont.dateFormat = "yyyy-MM"
            let dateM = dateFont.string(from: transaction.date)
            dateFont.dateFormat = "yyyy-MM-dd"
            let dateD = dateFont.string(from: transaction.date)

            db.collection("accounts").document(toAccountID).updateData([
                "transactions.\(dateM).\(dateD).\(Date())": postTransaction,
                "shareUsersID": updatedAccountInfo.shareUsersID,
                "accountInfo.expense": FieldValue.increment(transaction.amount),
                "accountInfo.total": FieldValue.increment(transaction.amount),
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    completion(.success("Sent successfully"))
                }
            }
    }

    func postData(toAccountID: String,
                  transaction: Transaction,
                  memberPayMoney: [String: Double],
                  memberShareMoney: [String: Double],
                  completion: @escaping (Result<Any, Error>) -> Void) {
        getAccountData(accountID: toAccountID) { result in
            switch result {
            case let .success(accountData):
                self.post(toAccountID: toAccountID,
                          transaction: transaction,
                          memberPayMoney: memberPayMoney,
                          memberShareMoney: memberShareMoney,
                          accountInfo: accountData)
                { result in
                    switch result {
                    case .success:
                        completion(.success(""))
                        print("---------------------")
                        print("success")
                    case .failure:
                        print("-----------------")
                        print("failure")
                        return
                    }
                }
            case .failure:
                return
            }
        }
    }

    func postUpdatePayerAccount(isMyAccount _: Bool,
                                formAccountName: String,
                                usersInfo: [UsersInfoResponse],
                                transaction: Transaction,
                                completion: @escaping (Result<Any, Error>) -> Void) {
        dateFont.dateFormat = "yyyy-MM"
        let dateM = dateFont.string(from: transaction.date)
        dateFont.dateFormat = "yyyy-MM-dd"
        let dateD = dateFont.string(from: transaction.date)
        // Get new write batch
        let batch = db.batch()

        for userInfo in usersInfo {
            if transaction.payUser?[userInfo.userID] != 0 {
                let inputTransaction: [String: Any] = [
                    "amount": transaction.payUser?[userInfo.userID],
                    "date": transaction.date,
                    "note": transaction.note,
                    "transactionType": ["iconName": transaction.transactionType.iconName, "name": transaction.transactionType.name],
                    "subType": ["iconName": transaction.subType.iconName, "name": transaction.subType.name],
                    "currency": "新台幣",
                    "from": formAccountName,
                ]

                // Update the population of 'userInfo.ownAccount'
                let sfRef = db.collection("accounts").document(userInfo.ownAccount)
                batch.updateData([
                    "transactions.\(dateM).\(dateD).\(transaction.date)": inputTransaction,
                    "accountInfo.expense": FieldValue.increment(-(transaction.payUser?[userInfo.userID] ?? 0)),
                    "accountInfo.total": FieldValue.increment(-(transaction.payUser?[userInfo.userID] ?? 0)),
                ],
                forDocument: sfRef)
            }
        }

        // Commit the batch
        batch.commit { err in
            if let err = err {
                print("Error committing batch: \(err)")
                completion(.failure(err))
            } else {
                print("Batch committed successfully.")
                completion(.success(""))
            }
        }
    }

    // MARK: - 取得帳本資料 -

    func getAccountData(accountID: String, completion: @escaping (Result<TransactionsResponse, Error>) -> Void) {
        // 從 Firebase 獲取數據
        let docRef = db.collection("accounts").document(accountID)

        docRef.getDocument { document, error in
            if let error = error as NSError? {
                self.errorMessage = "Error getting document: \(error.localizedDescription)"
            } else {
                if let document = document {
                    do {
                        
                        print("-----get account undecode Data------")
                        print("----\n\(document.data())")
                        let data = try document.data(as: TransactionsResponse.self)
                        print("-----get account decode Data------")
                        completion(.success(data))
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                }
            }
        }
    }

}
