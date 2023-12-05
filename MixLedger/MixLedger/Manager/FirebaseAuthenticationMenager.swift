//
//  FirebaseAuthenticationManager.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/5.
//

import Foundation
import FirebaseAuth

class FirebaseAuthenticationManager{
    static let shared = FirebaseAuthenticationManager()
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    static func checkUserAuthenticationState(completion: @escaping (Bool) -> Void) {
        if let user = shared.currentUser {
            // 用户已登录
            print("User is logged in with UID: \(user.uid)")
            completion(true)
        } else {
            // 用户未登录
            print("User is not logged in")
            completion(false)
        }
    }
    
    static func signOut() {
        do {
            try Auth.auth().signOut()
            if let window = SceneDelegate.shared.sceneWindow{
                ShowScreenManager.showSinginScreen(window: window)
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
