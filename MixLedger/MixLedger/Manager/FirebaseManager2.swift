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
                               let iconName = document.data()["iconName"] as? String {
                                
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
}
