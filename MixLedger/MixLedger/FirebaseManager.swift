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
    
    var accountData: TransactionsResponse?
    var userInfoData: [UsersInfoResponse]?
    @Published var errorMessage: String?
    
    let dateFont = DateFormatter()
    let date = Date()
    
    
    
    let transaction = [
    "amount": 100.0,
    "date": Date(),
    "payUser": ["puma","aaa"],
    "shareUser":["puma"],
    "note":"葡萄",
    "type": ["name" : "飲食",
             "iconName" : AllIcons.foodRice.rawValue],
    "currency": "新台幣",
    "from":""] as [String : Any]
    
    let accountInfo = ["accountID": "SUyJNUlNOAI26DREgF0T",
                    "accountName": "去嘉義玩",
                       "shareUsersID": ["users":[["userID":"QJeplpxVXBca5xhXWgbT","unbalance" : 300.0],
                            ["userID":"bGzuwR00sPRNmBamK91D","unbalance" : -300.0]
                           ]],
                       "accountInfo": ["total": 100.0, "expense": 300.0, "income": 600.0, "budget": 1000.0]
//                    "transaction.\(Date())":[]
    ] as [String : Any]

    
    func postData(){
        // 上傳到 Firebase
        dateFont.dateFormat = "yyyy-MM"
        let dateM = dateFont.string(from: date)
        dateFont.dateFormat = "yyyy-MM-dd"
        let dateD = dateFont.string(from: date)
        
        
//        db.collection("accounts").document("SUyJNUlNOAI26DREgF0T").setData(accountInfo) { err in
//          if let err = err {
//            print("Error writing document: \(err)")
//          } else {
//            print("Document successfully written!")
//          }
//        }
       
        
        
        db.collection("accounts").document("SUyJNUlNOAI26DREgF0T").updateData([
          "transactions.\(dateM).\(dateD).\(Date())": transaction,
          "shareUsersID.\("QJeplpxVXBca5xhXWgbT").unbalance": -500.0
        ]) { err in
          if let err = err {
            print("Error updating document: \(err)")
          } else {
            print("Document successfully updated")
          }
        }
        getData()
    }
    
    func getData(){
        // 從 Firebase 獲取數據
        let docRef = db.collection("accounts").document("SUyJNUlNOAI26DREgF0T")
        
        
        docRef.getDocument { document, error in
            if let error = error as NSError? {
              self.errorMessage = "Error getting document: \(error.localizedDescription)"
            }
            else {
              if let document = document {
                do {
                    print("----\n\(document.data())")
                  self.accountData = try document.data(as: TransactionsResponse.self)
                    print("-----------")
                    print("\(self.accountData)")
                }
                catch {
                  print(error)
                }
              }
            }
          }
        
//        docRef.getDocument(as: TransactionsResponse.self) { result in
//            switch result {
//            case .success(let data):
//
//                print("rqqqqq------")
//              self.data = data
//              self.errorMessage = nil
//                print(data)
//            case .failure(let error):
//              // A Book value could not be initialized from the DocumentSnapshot.
//              self.errorMessage = "Error decoding document: \(error.localizedDescription)"
//            }
//          }
        
//        docRef.getDocument { (document, error) in
//          if let document = document, document.exists {
//            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//            print("Document data: \(dataDescription)")
//              if let jsonData = dataDescription.data(using: .utf8) {
//                  do {
//                      let transactionsResponse = try JSONDecoder().decode(TransactionsResponse.self, from: jsonData)
//                      // 現在，transactionsResponse 包含了轉換後的資料
//                      print(transactionsResponse)
//                  } catch {
//                      print("解碼 JSON 時出錯：\(error.localizedDescription)")
//
//                  }
//              }
//          } else {
//            print("Document does not exist")
//          }
//        }
        
        
//        injuryRef.observeSingleEvent(of: .value) { snapshot in
//            if let injuryDictionary = snapshot.value as? [String: Any] {
//                do {
//                    let injury = try FirebaseDecoder().decode(Injury.self, from: injuryDictionary)
//                    print("Received injury from Firebase: \(injury)")
//                } catch {
//                    print("Error decoding injury: \(error.localizedDescription)")
//                }
//            }
//        }
    }
    
    func findUser(userID: [String]){
        userInfoData?.removeAll()
        for id in userID{
            let docRef = db.collection("users").document(id)
            docRef.getDocument { document, error in
                if let error = error as NSError? {
                  self.errorMessage = "Error getting document: \(error.localizedDescription)"
                }
                else {
                  if let document = document {
                    do {
                        let responseData = try document.data(as: UsersInfoResponse.self)
                        self.userInfoData?.append(responseData)
                        print("-----------")
                        print("\(self.userInfoData)")
                    }
                    catch {
                      print(error)
                    }
                  }
                }
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
        
        dateFont.dateFormat = "yyyy-MM"
        let dateM = dateFont.string(from: date)
        dateFont.dateFormat = "yyyy-MM-dd"
        let dateD = dateFont.string(from: date)
        
        
        let docRef = db.collection("accounts").document("SUyJNUlNOAI26DREgF0T").collection("transactions")
        
        docRef.document(dateM).updateData([dateM:transaction])
    }
}


struct TransactionsResponse: Codable {
    var transactions: [String: [String: [String: Transaction]]]
    var accountID: String
    var accountInfo: AccountInfo
    var accountName: String
    var shareUsersID: ShareUsers
}

struct AccountInfo: Codable {
    var budget: Double
    var expense: Double
    var income: Double
    var total: Double
}

struct ShareUsers: Codable {
    var users: [ShareUser]
}

struct ShareUser: Codable {
    var unbalance: Double
    var userID: String
}

struct Transaction: Codable {
    let amount: Double
    let currency: String
    let date: Date
    let from: String
    let note: String
    let payUser: [String]
    let shareUser: [String]
    let type: TransactionType
}

struct TransactionType: Codable {
    let iconName: String
    let name: String
}

struct UsersInfoResponse: Codable{
    var name: String
    var ownAccount: String
    var shareAccount: String
    var userID: String
}
