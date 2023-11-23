//
//  FirebaseManager.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/18.
//

import Foundation
import FirebaseCore
import FirebaseFirestore


class FirebaseManager{
    static let shared = FirebaseManager()
    
    let db = Firestore.firestore()
    
    let saveData = SaveData.shared
    
    @Published var errorMessage: String?
    
    let dateFont = DateFormatter()
    
//    
//    let accountInfo = ["accountID": "HbS5e81PWHRY41A8nBwl",
//                    "accountName": "去嘉義玩",
//                       "shareUsersID": ["users":[["userID":"QJeplpxVXBca5xhXWgbT","unbalance" : 0.0],
//                            ["userID":"bGzuwR00sPRNmBamK91D","unbalance" : 0.0]
//                           ]],
//                       "accountInfo": ["total": 100.0, "expense": 300.0, "income": 600.0, "budget": 1000.0]
//                    "transaction.\(Date())":[]
//    ] as [String : Any]
    
    func postRespondToInvitation(respond: Bool, accountID: String, completion: @escaping (Result<String, Error>)-> Void){
        
    }
    
    private func postAgareShareAccount(accountID: String, myID: String, completion: @escaping (Result<[UsersInfoResponse],Error>)-> Void){
        db.collection("accounts").document(accountID).updateData([
            "shareUsersID.": FieldValue.arrayUnion([])
        ]){ err in
            if let err = err {
              print("Error updating document: \(err)")
            } else {
              print("Document successfully updated postShareAccountToInivitee")
                
            }
          }
    }
    
    private func postShareAccountToInivitee(inviteeID: String, shareAccountID: String){
        guard let myName = saveData.myInfo?.name else { return print("no myName") }
        guard let accountName = saveData.accountData?.accountName else { return print("no accountName") }
        db.collection("users").document(inviteeID).updateData([
            "inviteCard" : FieldValue.arrayUnion([["accountID":shareAccountID, "inviterID": saveData.myInfo?.userID, "inviterName": myName, "accountName": accountName]])
        ]) { err in
          if let err = err {
            print("Error updating document: \(err)")
          } else {
            print("Document successfully updated postShareAccountToInivitee")
              
          }
        }
    }
    // 發送共享帳簿的邀請
    func postShareAccountInivite(inviteeID: String, shareAccountID: String, shareAccountName: String, inviterName: String, completion: @escaping (Result<[UsersInfoResponse],Error>)-> Void){
        db.collection("accounts").document(shareAccountID).updateData([
            "invitees" : FieldValue.arrayUnion([inviteeID])
        ]) { err in
          if let err = err {
            print("Error updating document: \(err)")
          } else {
            print("Document successfully updated")
              self.postShareAccountToInivitee(inviteeID: inviteeID, shareAccountID: shareAccountID)
          }
        }
    }
    
    func getAllUser(completion: @escaping (Result<[UsersInfoResponse],Error>)-> Void){
        db.collection("users").getDocuments() { (querySnapshot, err) in
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

    func addNewAccount(name: String, budget: Double? = 0, iconName: String){
        let newAccount = db.collection("account").document()
        guard let myInfo = saveData.myInfo else { return }
        let sharesID = [myInfo.userID: 0.0]
        let accountInfo = AccountInfo(budget: 0, expense: 0, income: 0, total: 0)
        let newAccountInfo = TransactionsResponse(accountID: newAccount.documentID, accountInfo: accountInfo, accountName: name, shareUsersID: sharesID, iconName: iconName )
        
        do {
            try db.collection("accounts").document(newAccount.documentID).setData(from: newAccountInfo) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    self.db.collection("users").document(myInfo.userID).updateData([
                        "shareAccount" : FieldValue.arrayUnion([newAccount.documentID])
                    ])
                    print("Document successfully written!")
                }
            }
        }catch let  error{
            print("Error writing city to Firestore: \(error)")
        }
        
        
    }
    
    func postData(toAccountID: String, amount: Double, date: Date, payUser: [String]?, shareUser: [String]?, note: String?, type: TransactionType?, completion: @escaping (Result<Any, Error>)-> Void){
        let transaction = [
        "amount": amount,
        "date": date,
        "payUser": payUser,
        "shareUser": shareUser,
        "note": note,
        "type": ["iconName": type?.iconName, "name": type?.name],
        "currency": "新台幣",
        "from":""] as [String : Any]
        
        let expense = ((saveData.accountData?.accountInfo.expense) ?? 0) - amount
        let total = ((saveData.accountData?.accountInfo.total) ?? 0) - amount
        print(expense)
        dateFont.dateFormat = "yyyy-MM"
        let dateM = dateFont.string(from: date)
        dateFont.dateFormat = "yyyy-MM-dd"
        let dateD = dateFont.string(from: date)
        
        db.collection("accounts").document(toAccountID).updateData([
          "transactions.\(dateM).\(dateD).\(Date())": transaction,
//          "shareUsersID.\("QJeplpxVXBca5xhXWgbT").unbalance": -500.0,
          "accountInfo.expense": FieldValue.increment(amount),
          "accountInfo.total": FieldValue.increment(amount),
        ]) { err in
          if let err = err {
            print("Error updating document: \(err)")
          } else {
            print("Document successfully updated")
              completion(.success("Sent successfully"))
              
          }
        }
//        getData()
    }
    
    func getData(accountID: String, completion: @escaping (Result<Any, Error>) -> Void){
        // 從 Firebase 獲取數據
        let docRef = db.collection("accounts").document(accountID)
        
        
        docRef.addSnapshotListener { document, error in
            if let error = error as NSError? {
              self.errorMessage = "Error getting document: \(error.localizedDescription)"
            }
            else {
              if let document = document {
                  do {
                      // print("----\n\(document.data())")
                      self.saveData.accountData = try document.data(as: TransactionsResponse.self)
                      print("-----get account Data------")
                      print("\(self.saveData.accountData?.accountName)")
                      completion(.success(self.saveData.accountData))
                  } catch {
                      print(error)
                      completion(.failure(error))
                  }
              }
            }
          }
        
    }
    
    func findUser(userID: [String], completion: @escaping (Result<[String : UsersInfoResponse], Error>) -> Void){

        if !userID.isEmpty{
            for id in userID{
                let docRef = db.collection("users").document(id)
                
                docRef.addSnapshotListener { document, error in
                    if let error = error as NSError? {
                      self.errorMessage = "Error getting document: \(error.localizedDescription)"
                        completion(.failure(error))
                    }
                    else {
                      if let document = document {
                          print("-----find User------")
                          print(document.data())
                        do {
                            let responseData = try document.data(as: UsersInfoResponse.self)
                            print(responseData)
                            completion(.success([id : responseData]))
                        }
                        catch {
                            print(error)
                            completion(.failure(error))
                        }
                      }
                    }
                  }
            }
        }
        print("\(self.saveData.userInfoData)")
//        completion(.success(saveData.userInfoData))
    }
    
    func findAccount(account: [String], completion: @escaping (Result<Any, Error>) -> Void){
        print("-------account array---------")
        print(account)
        
        let docRef = db.collection("accounts")
        if !account.isEmpty{
            
            docRef.whereField("accountID", in: account).getDocuments{  (querySnapshot, err) in
                if let err = err {
                  print("Error getting documents: \(err)")
                } else {
                    if let querySnapshot = querySnapshot{
                        for document in querySnapshot.documents {
        //                print("\(document.documentID) => \(document.data())")
                          print(document.data()["accountName"])
                          if let id = document.data()["accountID"] as? String/*, let name = [document.data()["accountName"]] as? String*/ {
                              self.saveData.myShareAccount[id] = document.data()["accountName"] as? String
                          }else{
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
    //MARK: -如果用子集合的寫法
    func getDate2(){
        // 從 Firebase 獲取數據
        let docRef = db.collection("accounts").document("SUyJNUlNOAI26DREgF0T").collection("")
        
        
        docRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting subcollection documents: \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        // 解析子集合的每個文件的數據
                        let transactionData = try document.data(as: TransactionsResponse.self)
                        print("Transaction Data: \(transactionData)")
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    func postData2(){
        
//        dateFont.dateFormat = "yyyy-MM"
//        let dateM = dateFont.string(from: date)
//        dateFont.dateFormat = "yyyy-MM-dd"
//        let dateD = dateFont.string(from: date)
        
        
        let docRef = db.collection("accounts").document("SUyJNUlNOAI26DREgF0T").collection("transactions")
        
//        docRef.document(dateM).updateData([dateM:transaction])
    }
}


struct TransactionsResponse: Codable {
    var transactions: [String: [String: [String: Transaction]]]?
    var accountID: String
    var accountInfo: AccountInfo
    var accountName: String
    var shareUsersID: [String: Double]?
    var iconName: String?
}

struct AccountInfo: Codable {
    var budget: Double
    var expense: Double
    var income: Double
    var total: Double
}

//struct ShareUsers: Codable {
//    var unbalance: Double
//    var userID: String
//}

struct ShareUsers: Codable {
    var users: [ShareUser]
}

struct ShareUser: Codable {
    var unbalance: Double
    var userID: String
}

struct Transaction: Codable {
    var amount: Double
    var currency: String
    var date: Date
    var from: String?
    var note: String?
    var payUser: [String]?
    var shareUser: [String]?
    var type: TransactionType?
}

struct TransactionType: Codable {
    var iconName: String?
    var name: String?
}

struct UsersInfoResponse: Codable{
    var name: String
    var ownAccount: String
    var shareAccount: [String]
    var userID: String
    var inviteCard: [InviteCard]?
}

struct InviteCard: Codable{
    var inviterID: String
    var accountID: String
    var accountName: String
    var inviterName: String
}
