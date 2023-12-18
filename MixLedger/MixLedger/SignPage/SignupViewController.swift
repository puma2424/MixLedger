//
//  SignupViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/4.
//

import SnapKit
import UIKit

class SignupViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupButton()
        setupLayout()
        setupTextField()
        view.backgroundColor = .g3()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    var uid: String?
    var userEmail: String?

    var nameText: String = ""
    var accountNameText: String = ""

    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        // 尚未輸入時的預設顯示提示文字
        textField.placeholder = "Your name"

        // 輸入框右邊顯示清除按鈕時機 這邊選擇當編輯時顯示
        textField.clearButtonMode = .whileEditing

        // 鍵盤上的 return 鍵樣式 這邊選擇 Done
        textField.returnKeyType = .done
        textField.textAlignment = .center
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(named: "G2")
        textField.textColor = UIColor(named: "G1")
        return textField
    }()

    let accountNameTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        // 尚未輸入時的預設顯示提示文字
        textField.placeholder = "Your ledger's name"

        // 輸入框右邊顯示清除按鈕時機 這邊選擇當編輯時顯示
        textField.clearButtonMode = .whileEditing

        // 鍵盤上的 return 鍵樣式 這邊選擇 Done
        textField.returnKeyType = .done
        textField.textAlignment = .center
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(named: "G2")
        textField.textColor = UIColor(named: "G1")
        return textField
    }()

    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.g3(), for: .normal)
        button.backgroundColor = .g2()
        button.layer.cornerRadius = 10
        return button
    }()

    @objc func nameTextFieldTarget(_ textField: UITextField) {
        nameText = textField.text ?? ""
        if nameText != "" && accountNameText != "" {
            submitButton.backgroundColor = .g1()
        } else {
            submitButton.backgroundColor = .g2()
        }
    }

    @objc func accountNameTextFieldTarget(_ textField: UITextField) {
        accountNameText = textField.text ?? ""
        if nameText != "" && accountNameText != "" {
            submitButton.backgroundColor = .g1()
        } else {
            submitButton.backgroundColor = .g2()
        }
    }

    @objc func submitButton(_: UIButton) {
        if nameText != "" && accountNameText != "" {
            singup()
        }
    }

    func singup() {
        guard let uid = uid else { return LKProgressHUD.showFailure(text: "註冊失敗") }
        guard let userEmail = userEmail else { return LKProgressHUD.showFailure(text: "註冊失敗") }

        let newUser = UsersInfoResponse(iconName: "human", name: nameText, ownAccount: "", shareAccount: [], userID: uid)
        FirebaseManager.postNewUser(uid: uid, email: userEmail, newUser: newUser, accountNAme: accountNameText) { result in
            switch result {
            case .success:
                LKProgressHUD.showSuccess(text: "成功創建新帳戶")
                self.dismiss(animated: true)
                if let window = SceneDelegate.shared.sceneWindow {
                    ShowScreenManager.showMainScreen(window: window)
                }
            case let .failure(err):
                LKProgressHUD.showFailure(text: "註冊失敗")
                self.dismiss(animated: true)
            }
        }
    }

    func setupTextField() {
        nameTextField.addTarget(self, action: #selector(nameTextFieldTarget(_:)), for: .editingChanged)
        accountNameTextField.addTarget(self, action: #selector(accountNameTextFieldTarget(_:)), for: .editingChanged)
    }

    func setupButton() {
        submitButton.addTarget(self, action: #selector(submitButton(_:)), for: .touchUpInside)
    }

    func setupLayout() {
        view.addSubview(nameTextField)
        view.addSubview(accountNameTextField)
        view.addSubview(submitButton)

        nameTextField.snp.makeConstraints { mark in
            mark.centerX.equalTo(view)
            mark.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            mark.width.equalTo(view.bounds.size.width * 0.85)
            mark.height.equalTo(50)
        }

        accountNameTextField.snp.makeConstraints { mark in
            mark.centerX.equalTo(view)
            mark.top.equalTo(nameTextField.snp.bottom).offset(50)
            mark.width.equalTo(view.bounds.size.width * 0.85)
            mark.height.equalTo(50)
        }

        submitButton.snp.makeConstraints { mark in
            mark.centerX.equalTo(view)
            mark.top.equalTo(accountNameTextField.snp.bottom).offset(50)
            mark.width.equalTo(view.bounds.size.width * 0.85)
            mark.height.equalTo(50)
        }
    }
}
