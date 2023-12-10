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
        if let data = datas?.inviteCard?[index.row] {
            firebaseManager.postRespondToInvitation(respond: true, accountID: data.accountID, accountName: data.accountName, inviterID: data.inviterID, inviterName: data.inviterName) { _ in
                print("--")
                self.datas = self.saveData.myInfo
                self.tableView.reloadData()
            }
        }    }

    func rejectInvitation(index: IndexPath) {
        if index.section == 0{
            print("agare in table \(index)")
            if let data = datas?.inviteCard?[index.row] {
                firebaseManager.postRespondToInvitation(respond: false, accountID: data.accountID, accountName: data.accountName, inviterID: data.inviterID, inviterName: data.inviterName) { _ in
                    print("--")
                    self.datas = self.saveData.myInfo
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func agare(index: IndexPath){
        if let data = datas?.message?[index.row] {
            if data.isDunningLetter{
                firebaseManager.confirmPayment(messageInfo: data, textToOtherUser: "", textToMyself: ""){_ in
                    return
                }
            }
        }
    }
    
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            "Account Invitation"
        }else {
            "Message"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            let inviteCardCount = datas?.inviteCard?.count ?? 1
            if inviteCardCount == 0 {
                return 1
            }else {
                return inviteCardCount
            }
        }else{
            let messageCount = datas?.message?.count ?? 0
            return messageCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell", for: indexPath)
        guard let inviteCell = cell as? InviteMessageTableViewCell else { return cell }
        if indexPath.section == 0{
            if let data = datas?.inviteCard {
                if data.count > 0{
                    inviteCell.setupLayoutIncludeBothButton()
                    inviteCell.inviteMessageLabel.text = "\(data[indexPath.row].inviterName)邀請你加入帳簿：\(data[indexPath.row].accountName)"
                    
                    inviteCell.agreeClosure = { [weak self] in
                        self?.agareInvitation(index: indexPath)
                    }
                    
                    inviteCell.rejectClosure = { [weak self] in
                        self?.rejectInvitation(index: indexPath)
                    }
                }else {
                    inviteCell.setupLayoutNoButton()
                    inviteCell.inviteMessageLabel.text = "No Account Invitation"
                }
            }else {
                inviteCell.setupLayoutNoButton()
                inviteCell.inviteMessageLabel.text = "No Account Invitation"
            }
        }else{
            if let data = datas?.message?[indexPath.row] {
                if data.isDunningLetter {
                    
                    if data.fromUserID == saveData.myInfo?.userID{
                        inviteCell.setupLayoutNoButton()
                        inviteCell.inviteMessageLabel.text = data.toSenderMessage
                    }else{
                        inviteCell.setupLayoutJustAgreeButton()
//                        inviteCell.setupLayoutIncludeBothButton()
                        inviteCell.inviteMessageLabel.text = data.toReceiverMessage
                    }
                    
                }else {
                    inviteCell.setupLayoutNoButton()
                    
                    if data.fromUserID == saveData.myInfo?.userID{
                        inviteCell.inviteMessageLabel.text = data.toSenderMessage
                    }else{
                        inviteCell.inviteMessageLabel.text = data.toReceiverMessage
                    }
                   
                }
            }

            inviteCell.agreeClosure = { [weak self] in
                self?.agare(index: indexPath)
            }

        }

        return inviteCell
    }
}
