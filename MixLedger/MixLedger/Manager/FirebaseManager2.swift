//
//  FirebaseManager2.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/4.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

extension FirebaseManager{
    // MARK: - 新增帳號
    func postNewOwnAccount(uid: String, accountNAme: String, completion: @escaping (Result<String, Error>) -> Void){
        let newAccount = self.db.collection("account").document()
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
    static func postNewUser(uid: String, email: String, newUser: UsersInfoResponse, accountNAme: String, completion: @escaping (Result<String, Error>) -> Void){
        self.shared.postNewOwnAccount(uid: uid, accountNAme: accountNAme){result in
            switch result {
            case .success(let newAccountID):
                do {
                    var user = newUser
                    user.ownAccount = newAccountID
                    try self.shared.db.collection("users").document(uid).setData(from: user){ err in
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
            case .failure(let err):
                print(err)
                completion(.failure(err))
            }
            
        }
        
        
    }

}