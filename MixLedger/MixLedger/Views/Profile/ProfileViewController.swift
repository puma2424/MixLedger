//
//  ProfileViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/4.
//

import SnapKit
import UIKit

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupview()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUser()
    }

    let fullScreenSize = UIScreen.main.bounds.size

    var userIconName: String?

    let userImageButton: UIButton = {
        let button = UIButton()
        button.setImage(AllIcons.human.icon, for: .normal)
        button.backgroundColor = .brightGreen4()
        return button
    }()

    let checkChuangButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .g2()
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setTitle("確 認 變 更", for: .normal)
        return button
    }()

    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .g1()
//        label.font = UIFont.systemFont(ofSize: 30)
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()

    let singOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.g3(), for: .normal)
        button.backgroundColor = .brightGreen3()
        return button
    }()

    @objc func appleSingOutButtonTapped() {
        FirebaseAuthenticationManager.signOut()
    }

    @objc func userImageButtonTapped() {
//        let subTypeVC = SelectUserIconViewController()
        let subTypeVC = SelectIconViewController(iconGroup: SelectIconManager().userIconGroup)
        subTypeVC.modalPresentationStyle = .automatic
        subTypeVC.modalTransitionStyle = .coverVertical
        subTypeVC.sheetPresentationController?.detents = [.custom(resolver: { context in
            context.maximumDetentValue * 0.5
        }
        )]

        subTypeVC.selectedSubType = { iconName, _ in
            self.userIconName = iconName
            self.changCheckButtonColor()
        }

        present(subTypeVC, animated: true, completion: nil)
    }

    @objc func checkChuangButtonTapped() {
        if let userIconName = userIconName {
            FirebaseManager.postUpdataUserInfo(iconName: userIconName, name: nil) { result in
                switch result {
                case .success:
                    LKProgressHUD.showSuccess()
                case let .failure(err):
                    print(err)
                    LKProgressHUD.showFailure()
                }
                self.userIconName = nil
                self.changCheckButtonColor()
                self.setupUser()
            }
            print("post change")
        } else {
            ShowCustomAlertManager.customAlert(title: "點選頭貼可以變更頭像喔～", message: "", vc: self) {}
        }
    }

    func setupUser() {
        print("setUserImage")
        if let userInfo = SaveData.shared.myInfo,
           let userImage = UserImageItem.item(userInfo.iconName)
        {
            userImageButton.setImage(userImage.image, for: .normal)
            userNameLabel.text = userInfo.name
        } else {
            userImageButton.setImage(UserImageItem.human.image, for: .normal)
        }
    }

    func changCheckButtonColor() {
        if let userIconName = userIconName {
            checkChuangButton.backgroundColor = .brightGreen3()
        } else {
            checkChuangButton.backgroundColor = .g2()
        }
    }

    func setupview() {
        setupLayout()
        setupButton()
    }

    func setupButton() {
        userImageButton.layer.cornerRadius = fullScreenSize.width * 0.2
        singOutButton.layer.cornerRadius = 10

        userImageButton.addTarget(self, action: #selector(userImageButtonTapped), for: .touchUpInside)
        singOutButton.addTarget(self, action: #selector(appleSingOutButtonTapped), for: .touchUpInside)
        checkChuangButton.addTarget(self, action: #selector(checkChuangButtonTapped), for: .touchUpInside)
    }

    func setupLayout() {
        view.addSubview(singOutButton)
        view.addSubview(checkChuangButton)
        view.addSubview(userImageButton)
        view.addSubview(userNameLabel)

        userImageButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.height.width.equalTo(fullScreenSize.width * 0.4)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
        }

        checkChuangButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(fullScreenSize.width * 0.8)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(singOutButton.snp.top).offset(-30)
        }

        singOutButton.snp.makeConstraints { mark in
            mark.height.equalTo(50)
            mark.width.equalTo(fullScreenSize.width * 0.8)
            mark.centerX.equalTo(view.safeAreaLayoutGuide)
            mark.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }

        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageButton.snp.bottom).offset(30)
            make.centerX.equalTo(view).priority(.required)
            make.width.lessThanOrEqualTo(fullScreenSize.width * 0.8)
        }
    }
}
