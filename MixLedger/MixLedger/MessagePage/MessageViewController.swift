//
//  MessageViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/22.
//

import SnapKit
import UIKit
class MessageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTable()
        setupLayout()

        navigationItem.title = "通知"
        // 在訂閱者處註冊通知
        NotificationCenter.default.addObserver(self, selector: #selector(handleMessageNotification), name: .myMessageNotification, object: nil)

        view.backgroundColor = .g3()
    }

    // 處理通知的方法
    @objc func handleMessageNotification() {
        datas = saveData.myInfo
        tableView.reloadData()
        print("Notification received!")
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
        datas = saveData.myInfo
        tableView.reloadData()
    }

    let firebaseManager = FirebaseManager.shared

    var datas: UsersInfoResponse?

    let saveData = SaveData.shared

    var tableView = UITableView()

    func setupTable() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .g3()
        tableView.register(InviteMessageTableViewCell.self, forCellReuseIdentifier: "inviteCell")
    }

    func setupLayout() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { mark in
            mark.leading.equalTo(view.safeAreaLayoutGuide)
            mark.top.equalTo(view.safeAreaLayoutGuide)
            mark.trailing.equalTo(view.safeAreaLayoutGuide)
            mark.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func agareInvitation(index: IndexPath) {
        print("agare in table \(index)")
        print(datas?.inviteCard?[index.row])
        LKProgressHUD.show()

        if let data = datas?.inviteCard?[index.row] {
            firebaseManager.postRespondToInvitation(respond: true, accountID: data.accountID, accountName: data.accountName, inviterID: data.inviterID, inviterName: data.inviterName) { result in
                switch result {
                case let .success(success):
                    print("--")
                    self.datas = self.saveData.myInfo
                    self.tableView.reloadData()
                    LKProgressHUD.showSuccess()
                case let .failure(failure):
                    LKProgressHUD.showFailure()
                }
            }
        } else {
            LKProgressHUD.dismiss()
        }
    }

    func rejectInvitation(index: IndexPath) {
        LKProgressHUD.show()
        if index.section == 0 {
            print("agare in table \(index)")

            if let data = datas?.inviteCard {
                let inviteCard = data[index.row]
                firebaseManager.postRespondToInvitation(respond: false,
                                                        accountID: inviteCard.accountID,
                                                        accountName: inviteCard.accountName,
                                                        inviterID: inviteCard.inviterID,
                                                        inviterName: inviteCard.inviterName)
                { result in
                    switch result {
                    case let .success(success):
                        print("--")
                        self.datas = self.saveData.myInfo
                        self.tableView.reloadData()
                        LKProgressHUD.showSuccess()
                    case let .failure(failure):
                        LKProgressHUD.showFailure()
                    }
                }
            } else {
                LKProgressHUD.dismiss()
            }
        } else {
            LKProgressHUD.dismiss()
        }
    }

    func agare(index: IndexPath) {
        LKProgressHUD.show()
        if let data = datas?.message?[index.row] {
            if data.isDunningLetter {
                firebaseManager.confirmPayment(messageInfo: data, textToOtherUser: "", textToMyself: "") { result in
                    switch result {
                    case let .success(success):

                        LKProgressHUD.showSuccess()
                    case let .failure(failure):
                        LKProgressHUD.showFailure()
                    }
                }
            } else {
                LKProgressHUD.dismiss()
            }
        } else {
            LKProgressHUD.showFailure()
        }
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        2
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            "Account Invitation"
        } else {
            "Message"
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            let inviteCardCount = datas?.inviteCard?.count ?? 1
            if inviteCardCount == 0 {
                return 1
            } else {
                return inviteCardCount
            }
        } else {
            let messageCount = datas?.message?.count ?? 1
            if messageCount == 0 {
                return 1
            } else {
                return messageCount
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell", for: indexPath)
        cell.selectionStyle = .none
        guard let inviteCell = cell as? InviteMessageTableViewCell else { return cell }
        if indexPath.section == 0 {
            if let data = datas?.inviteCard {
                if data.count > 0 {
                    inviteCell.inviteMessageLabel.textColor = .g1()
                    inviteCell.setupLayoutIncludeBothButton()
                    inviteCell.inviteMessageLabel.text = "\(data[indexPath.row].inviterName)邀請你加入帳簿：\(data[indexPath.row].accountName)"

                    inviteCell.agreeClosure = { [weak self] in
                        self?.agareInvitation(index: indexPath)
                    }

                    inviteCell.rejectClosure = { [weak self] in
                        self?.rejectInvitation(index: indexPath)
                    }
                } else {
                    inviteCell.setupLayoutNoButton()
                    inviteCell.inviteMessageLabel.text = "No Any Account Invitation"
                    inviteCell.inviteMessageLabel.textColor = .gray
                }
            } else {
                inviteCell.setupLayoutNoButton()
                inviteCell.inviteMessageLabel.text = "No Any Account Invitation"
                inviteCell.inviteMessageLabel.textColor = .gray
            }
        } else {
            if datas?.message?.count != 0,
               datas?.message != nil
            {
                if let data = datas?.message?[indexPath.row] {
                    inviteCell.inviteMessageLabel.textColor = .g1()
                    if data.isDunningLetter {
                        if data.fromUserID == saveData.myInfo?.userID {
                            inviteCell.setupLayoutNoButton()
                            inviteCell.inviteMessageLabel.text = data.toSenderMessage
                        } else {
                            inviteCell.setupLayoutJustAgreeButton()
                            //                        inviteCell.setupLayoutIncludeBothButton()
                            inviteCell.inviteMessageLabel.text = data.toReceiverMessage
                        }

                    } else {
                        inviteCell.setupLayoutNoButton()

                        if data.fromUserID == saveData.myInfo?.userID {
                            inviteCell.inviteMessageLabel.text = data.toSenderMessage
                        } else {
                            inviteCell.inviteMessageLabel.text = data.toReceiverMessage
                        }
                    }
                }
            } else {
                inviteCell.setupLayoutNoButton()
                inviteCell.inviteMessageLabel.text = "No Any Message"
                inviteCell.inviteMessageLabel.textColor = .gray
            }

            inviteCell.agreeClosure = { [weak self] in
                self?.agare(index: indexPath)
            }
        }

        return inviteCell
    }

    func deleteMessage(indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let data = datas?.inviteCard?[indexPath.row] {
                FirebaseManager.postDeleteInvitation(accountID: data.accountID,
                                                     accountName: data.accountName,
                                                     inviterID: data.inviterID,
                                                     inviterName: data.inviterName)
                { result in
                    switch result {
                    case let .success(success):
                        self.datas?.inviteCard?.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    case let .failure(failure):
                        print(failure)
                        return
                    }
                }
            }
        } else {
            if let data = datas?.message?[indexPath.row] {
                FirebaseManager.postDeleteMessage(userID: saveData.myID, messageInfo: data) { result in
                    switch result {
                    case let .success(success):
                        self.datas?.message?.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    case let .failure(failure):
                        return
                    }
                }
            }
        }
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteMessage(indexPath: indexPath)
        }
    }

    // 啟用滑動刪除功能
    func tableView(_: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            if datas?.inviteCard?.count == 0 {
                return .none
            }
        } else {
            if datas?.message?.count == 0 || datas?.message == nil {
                return .none
            }
        }
        return .delete
    }

    // 提供刪除按鈕的標題，你可以自定義這個按鈕的外觀
    func tableView(_: UITableView, titleForDeleteConfirmationButtonForRowAt _: IndexPath) -> String? {
        return "刪除"
    }
}
