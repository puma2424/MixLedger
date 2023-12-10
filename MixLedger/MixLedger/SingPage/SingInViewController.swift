//
//  SingInViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/4.
//

import AuthenticationServices
import CryptoKit // 用來產生隨機字串 (Nonce) 的
import FirebaseAuth
import SnapKit
import UIKit

class SingInViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupButton()
        setupLayout()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    let firebaseManager = FirebaseManager.shared
    let singButton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)

    // MARK: - Sign in with Apple 登入

    fileprivate var currentNonce: String?

    @objc func appleSinginButtonTapped() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    @objc func appleSingOutButtonTapped() {
        FirebaseAuthenticationManager.signOut()
    }

    func setupButton() {
        singButton.cornerRadius = 10
        singButton.addTarget(self, action: #selector(appleSinginButtonTapped), for: .touchUpInside)
    }

    func setupLayout() {
        view.addSubview(singButton)

        singButton.snp.makeConstraints { mark in
            mark.height.equalTo(50)
            mark.width.equalTo(view.bounds.size.width * 0.5)
            mark.centerX.equalTo(view)
            mark.centerY.equalTo(view)
        }
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}

extension SingInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // 登入成功
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                LKProgressHUD.showFailure(text: "Unable to fetch identity token")
//                CustomFunc.customAlert(title: "", message: "Unable to fetch identity token", vc: self, actionHandler: nil)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                LKProgressHUD.showFailure(text: "Unable to serialize token string from data\n\(appleIDToken.debugDescription)")
//                CustomFunc.customAlert(title: "", message: "Unable to serialize token string from data\n\(appleIDToken.debugDescription)", vc: self, actionHandler: nil)
                return
            }
            // 產生 Apple ID 登入的 Credential
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            // 與 Firebase Auth 進行串接
            firebaseSignInWithApple(credential: credential)
        }
    }

    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
        // 登入失敗，處理 Error
        switch error {
        case ASAuthorizationError.canceled:
            LKProgressHUD.showFailure(text: "使用者取消登入")
//            CustomFunc.customAlert(title: "使用者取消登入", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.failed:
            LKProgressHUD.showFailure(text: "授權請求失敗")
//            CustomFunc.customAlert(title: "授權請求失敗", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.invalidResponse:
            LKProgressHUD.showFailure(text: "授權請求無回應")
//            CustomFunc.customAlert(title: "授權請求無回應", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.notHandled:
            LKProgressHUD.showFailure(text: "授權請求未處理")
//            CustomFunc.customAlert(title: "授權請求未處理", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.unknown:
            LKProgressHUD.showFailure(text: "授權失敗，原因不知")
//            CustomFunc.customAlert(title: "授權失敗，原因不知", message: "", vc: self, actionHandler: nil)
        default:
            break
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

// 在畫面上顯示授權畫面
extension SingInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

extension SingInViewController {
    // MARK: - 透過 Credential 與 Firebase Auth 串接

    func firebaseSignInWithApple(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { _, error in
            guard error == nil else {
                LKProgressHUD.showFailure(text: "\(String(describing: error!.localizedDescription))")
//                CustomFunc.customAlert(title: "", message: "\(String(describing: error!.localizedDescription))", vc: self, actionHandler: nil)
                return
            }
//            LKProgressHUD.showSuccess(text: "登入成功！")
            self.getFirebaseUserInfo()
//            CustomFunc.customAlert(title: "登入成功！", message: "", vc: self, actionHandler: self.getFirebaseUserInfo)
        }
    }

    // MARK: - Firebase 取得登入使用者的資訊

    func getFirebaseUserInfo() {
        let currentUser = Auth.auth().currentUser
        guard let user = currentUser else {
            LKProgressHUD.showFailure(text: "無法取得使用者資料！")
//            CustomFunc.customAlert(title: "無法取得使用者資料！", message: "", vc: self, actionHandler: nil)
            return
        }
        let uid = user.uid
        let email = user.email
        let token = user.refreshToken
        SaveData.shared.myID = uid
        firebaseManager.getUsreInfo(userID: [uid]) { result in
            switch result {
            case let .success(data):
                if data.count == 0 {
                    LKProgressHUD.showFailure(text: "帳號未註冊")
                    print(user.displayName)
                    print(uid)
                    print(email)
                    let singupVC = SingupViewController()
                    singupVC.uid = uid
                    singupVC.userEmail = email
                    self.present(singupVC, animated: true)
                } else {
                    if let window = SceneDelegate.shared.sceneWindow {
                        ShowScreenManager.showMainScreen(window: window)
                    }
                    LKProgressHUD.showSuccess(text: "登入成功！")
                }
            case .failure:
                LKProgressHUD.showFailure(text: "無法取得使用者資料！")
            }
        }
//        CustomFunc.customAlert(title: "使用者資訊", message: "UID：\(uid)\nEmail：\(email!)", vc: self, actionHandler: nil)
    }
}
