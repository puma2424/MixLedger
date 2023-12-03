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
        setupLayout()
        setupTable()
        navigationItem.title = "通知"
        // 在訂閱者處註冊通知
        NotificationCenter.default.addObserver(self, selector: #selector(handleMessageNotification), name: .myMessageNotification, object: nil)
        
        
        
    }
    // 處理通知的方法
    @objc func handleMessageNotification() {
        data = saveData.myInfo
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
        data = saveData.myInfo
        tableView.reloadData()
    }

    let firebaseManager = FirebaseManager.shared

    var data: UsersInfoResponse?

    let saveData = SaveData.shared

    let tableView = UITableView()

    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self

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

    func agare(index: IndexPath) {
        if index.section == 0{
            print("agare in table \(index)")
            print(data?.inviteCard?[index.row])
            if let data = data?.inviteCard?[index.row] {
                firebaseManager.postRespondToInvitation(respond: true, accountID: data.accountID, accountName: data.accountName, inviterID: data.inviterID, inviterName: data.inviterName) { _ in
                    print("--")
                    self.data = self.saveData.myInfo
                    self.tableView.reloadData()
                }
            }
        }else{
            if let data = data?.message?[index.row] {
                if data.isDunningLetter{
                    firebaseManager.confirmPayment(messageInfo: data, textToOtherUser: "", textToMyself: ""){_ in
                        return
                    }
                }
            }
        }
        
    }

    func reject(index: IndexPath) {
        if index.section == 0{
            print("agare in table \(index)")
//            if let data = data?.inviteCard?[index.row] {
//                firebaseManager.postRespondToInvitation(respond: false, accountID: data.accountID, accountName: data.accountName, inviterID: data.inviterID, inviterName: data.inviterName) { _ in
//                    print("--")
//                    self.data = self.saveData.myInfo
//                    self.tableView.reloadData()
//                }
//            }
        }
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            let inviteCardCount = data?.inviteCard?.count ?? 0
            return inviteCardCount
        }else{
            let messageCount = data?.message?.count ?? 0
            return messageCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell", for: indexPath)
        guard let inviteCell = cell as? InviteMessageTableViewCell else { return cell }
        if indexPath.section == 0{
            if let data = data?.inviteCard?[indexPath.row] {
                inviteCell.inviteMessageLabel.text = "\(data.inviterName)邀請你加入帳簿：\(data.accountName)"
            }

            inviteCell.agreeClosure = { [weak self] in
                self?.agare(index: indexPath)
            }

            inviteCell.rejectClosure = { [weak self] in
                self?.reject(index: indexPath)
            }
        }else{
            
            if let data = data?.message?[indexPath.row] {
                if data.fromUserID == saveData.myInfo?.userID{
                    inviteCell.inviteMessageLabel.text = data.toSenderMessage
                }else{
                    inviteCell.inviteMessageLabel.text = data.toReceiverMessage
                }
                
            }

            inviteCell.agreeClosure = { [weak self] in
                self?.agare(index: indexPath)
            }

            inviteCell.rejectClosure = { [weak self] in
                self?.reject(index: indexPath)
            }
        }

        return inviteCell
    }
}
