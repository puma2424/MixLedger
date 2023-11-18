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
        var amo: String
        var severity: String
    }
    static let shared = FirebaseManager()
    let db = Firestore.firestore()

//    // 創建一個 Injury 實例
//    let injury = Injury(type: "Cut", severity: "Moderate")
//    let injuryRef = Database.database().reference().child("injuries")
    
    func postData(){
        // 上傳到 Firebase
        
//        let injuryDictionary = try! FirebaseEncoder().encode(injury)
//        injuryRef.setValue(injuryDictionary)
    }

    func getData(){
        // 從 Firebase 獲取數據
        let docRef = db.collection("accounts").document("SUyJNUlNOAI26DREgF0T")
        docRef.getDocument { (document, error) in
          if let document = document, document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
          } else {
            print("Document does not exist")
          }
        }
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
