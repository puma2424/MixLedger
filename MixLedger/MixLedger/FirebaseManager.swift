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
    struct Transaction: Codable {
        var amount: Double
        var date: Date
        var note: String
        var payUser: [String]
        var shareUser: [String]
        var type: [String]
    }

    struct TransactionsResponse: Codable {
        var transactions: [String: Transaction]?
        var shareUser: String
    }
    static let shared = FirebaseManager()
    let db = Firestore.firestore()
    let transaction = [
    "amount": 100.0,
    "date": Date(),
    "payUser": ["puma","aaa"],
    "shareUser":["puma"],
    "note":"葡萄",
    "type": ["飲食"],
    "from":""] as [String : Any]
//    // 創建一個 Injury 實例
//    let injury = Injury(type: "Cut", severity: "Moderate")
//    let injuryRef = Database.database().reference().child("injuries")
    
    func postData(){
        // 上傳到 Firebase
        
//        let injuryDictionary = try! FirebaseEncoder().encode(injury)
//        injuryRef.setValue(injuryDictionary)

//        let postData:Transaction = Transaction(amount: 300, date: Date(), note: "早餐", payUser: ["aaa"], shareUser: ["aaa","puma"], type: ["飲食"])
        let postData = ["accountID": "SUyJNUlNOAI26DREgF0T",
                        "accountName": "去嘉義玩",
                        "shareUsersID": ["QJeplpxVXBca5xhXWgbT", "bGzuwR00sPRNmBamK91D"],
                        "accountInfo": ["total": 100.0, "expense": 300.0, "income": 600.0, "budget": 1000.0],
                        "transaction.\(Date())":[]] as [String : Any]
        
        let docRef = db.collection("accounts").document("SUyJNUlNOAI26DREgF0T")
        
        
        
//        db.collection("accounts").document("SUyJNUlNOAI26DREgF0T").setData(postData){ err in
//            if let err = err {
//              print("Error writing document: \(err)")
//            } else {
//              print("Document successfully written!")
//            }
//          }
        
        db.collection("accounts").document("SUyJNUlNOAI26DREgF0T").updateData([
          "transactions.\(Date())": transaction
        ]) { err in
          if let err = err {
            print("Error updating document: \(err)")
          } else {
            print("Document successfully updated")
          }
        }
        getData()
    }
    @Published var errorMessage: String?
    var data: TransactionsResponse?
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
                  self.data = try document.data(as: TransactionsResponse.self)
                    print("-----------")
                    print("\(self.data)")
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
    
    
}
