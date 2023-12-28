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
        setupNotificationCenter()
        navigationItem.title = "通知"
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
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleMessageNotification), name: .myMessageNotification, object: nil)
    }

    // 處理通知的方法
    @objc func handleMessageNotification() {
        datas = saveData.myInfo
        tableView.reloadData()
        print("Notification received!")
    }
    
    private func handleInvitationResponse(
        respond: Bool,
        accountID: String,
        accountName: String,
        inviterID: String,
        inviterName: String) {
            LKProgressHUD.show()
            firebaseManager.postRespondToInvitation(
                respond: respond,
                accountID: accountID,
                accountName: accountName,
                inviterID: inviterID,
                inviterName: inviterName) { result in
                    switch result {
                    case .success:
                        self.datas = self.saveData.myInfo
                        self.tableView.reloadData()
                        LKProgressHUD.showSuccess()
                    case let .failure(error):
                        LKProgressHUD.showFailure()
                        print(error)
                    }
                }
        }

    func agareInvitation(index: IndexPath) {
        guard let data = datas?.inviteCard?[index.row] else {
            return LKProgressHUD.showFailure()
        }
        
        guard SaveData.shared.myInfo?.shareAccount.contains(data.accountID) != true else {
            ShowCustomAlertManager.customAlert(
                title: "已加入共享帳本",
                message: "你已在共享帳本中",
                vc: self,
                actionHandler: nil
            )
            return
        }
        
        handleInvitationResponse(
            respond: true,
            accountID: data.accountID,
            accountName: data.accountName,
            inviterID: data.inviterID,
            inviterName: data.inviterName)
        
    }

    func rejectInvitation(index: IndexPath) {
        guard let data = datas?.inviteCard?[index.row] else {
            return LKProgressHUD.showFailure()
        }
        
        handleInvitationResponse(
            respond: false,
            accountID: data.accountID,
            accountName: data.accountName,
            inviterID: data.inviterID,
            inviterName: data.inviterName)
    }

    func agare(index: IndexPath) {
        guard let data = datas?.message?[index.row],
                data.isDunningLetter else {
                LKProgressHUD.showFailure()
                return
            }

            LKProgressHUD.show()

            firebaseManager.confirmPayment(messageInfo: data) { result in
                switch result {
                case .success:
                    LKProgressHUD.showSuccess()
                case .failure:
                    LKProgressHUD.showFailure()
                }
            }
    }
    
    func deleteMessage(indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let data = datas?.inviteCard?[indexPath.row] {
                FirebaseManager.postDeleteInvitation(accountID: data.accountID,
                                                     accountName: data.accountName,
                                                     inviterID: data.inviterID,
                                                     inviterName: data.inviterName) { result in
                    switch result {
                    case .success(_):
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
                    case .success(_):
                        self.datas?.message?.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    case let .failure(failure):
                        print(failure)
                        print(failure)
                        print(failure)
                        return
                    }
                }
            }
        }
    }
    
    private func configureInviteCell(_ cell: InviteMessageTableViewCell, forInviteCardAt indexPath: IndexPath) {
        if let data = datas?.inviteCard, data.count > 0 {
            cell.inviteMessageLabel.textColor = .g1()
            cell.setupLayoutIncludeBothButton()
            cell.inviteMessageLabel.text = "\(data[indexPath.row].inviterName)邀請你加入帳簿：\(data[indexPath.row].accountName)"

            cell.agreeClosure = { [weak self] in
                self?.agareInvitation(index: indexPath)
            }

            cell.rejectClosure = { [weak self] in
                self?.rejectInvitation(index: indexPath)
            }
        } else {
            cell.setupLayoutNoButton()
            cell.inviteMessageLabel.text = "No Any Account Invitation"
            cell.inviteMessageLabel.textColor = .gray
        }
    }

    private func configureMessageCell(_ cell: InviteMessageTableViewCell, forMessageAt indexPath: IndexPath) {
        guard let data = datas?.message, data.count > indexPath.row else {
            cell.setupLayoutNoButton()
            cell.inviteMessageLabel.text = "No Any Message"
            cell.inviteMessageLabel.textColor = .gray
            return
        }

        cell.inviteMessageLabel.textColor = .g1()

        if let messageData = datas?.message?[indexPath.row] {
            if messageData.isDunningLetter {
                cell.setupLayoutNoButton()

                if messageData.fromUserID == saveData.myInfo?.userID {
                    cell.inviteMessageLabel.text = messageData.toSenderMessage
                } else {
                    cell.setupLayoutJustAgreeButton()
                    cell.inviteMessageLabel.text = messageData.toReceiverMessage
                }

            } else {
                cell.setupLayoutNoButton()

                if messageData.fromUserID == saveData.myInfo?.userID {
                    cell.inviteMessageLabel.text = messageData.toSenderMessage
                } else {
                    cell.inviteMessageLabel.text = messageData.toReceiverMessage
                }
            }
        }

        cell.agreeClosure = { [weak self] in
            self?.agare(index: indexPath)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell", for: indexPath)
            cell.selectionStyle = .none
            guard let inviteCell = cell as? InviteMessageTableViewCell else { return cell }

            switch indexPath.section {
            case 0:
                configureInviteCell(inviteCell, forInviteCardAt: indexPath)
            default:
                configureMessageCell(inviteCell, forMessageAt: indexPath)
            }

            return inviteCell
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
