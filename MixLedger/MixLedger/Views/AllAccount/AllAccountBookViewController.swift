//
//  AllAccountBookViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import SnapKit
import UIKit
class AllAccountBookViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setTable()
        setLayout()
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(handleAccountNotification),
                                               name: .myMessageNotification,
                                               object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        findAllMyAccount()
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
    let savaData = SaveData.shared
    var accountInfo: ((String) -> Void)?
    var table = UITableView()
    var selectedIndexPath: IndexPath?

    func setTable() {
        table = UITableView(frame: view.bounds, style: .insetGrouped)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor(named: "G3")
        table.register(AccountTableViewCell.self, forCellReuseIdentifier: "accountCell")
    }

    @objc func handleAccountNotification() {
        findAllMyAccount()
    }

    @objc func backHome() {
        print("editAccountBook")
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func addNewAccount() {
        print("shareAccountBook")
        present(AddNewAccountViewController(), animated: true)
    }

    func findAllMyAccount() {
        if let myInfo = savaData.myInfo {
            let shareAccount = myInfo.shareAccount
            let myAccount = [myInfo.ownAccount]
            let allAccount: [String] = myAccount + shareAccount
            firebaseManager.findAccount(account: allAccount) { _ in
                self.table.reloadData()
            }
        }
    }

    func setLayout() {
        view.addSubview(table)
        table.snp.makeConstraints { mark in
            mark.top.equalTo(view.safeAreaLayoutGuide)
            mark.leading.equalTo(view.safeAreaLayoutGuide)
            mark.bottom.leading.equalTo(view.safeAreaLayoutGuide)
            mark.trailing.leading.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setNavigation() {
        // 導覽列左邊按鈕
        let backHomeButton = UIBarButtonItem(
            image: UIImage(named: AllIcons.icons8Back.rawValue)?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(backHome)
        )
        // 加到導覽列中
        navigationItem.leftBarButtonItem = backHomeButton

        // 導覽列右邊按鈕
        let addNewAccount = UIBarButtonItem(
            //          title:"設定",
            image: UIImage(named: AllIcons.add2.rawValue)?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(addNewAccount)
        )
        // 加到導覽列中
        navigationItem.rightBarButtonItem = addNewAccount
    }
}

extension AllAccountBookViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        2
    }

    func tableView(_: UITableView, numberOfRowsInSection: Int) -> Int {
        guard let data = savaData.myInfo else { return 0 }
        if numberOfRowsInSection == 0 {
            return 1
        } else {
            return data.shareAccount.count
        }
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "My Account"
        } else {
            return "Share Account"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath)
        cell.backgroundColor = .brightGreen4()
        cell.selectionStyle = .none
        guard let accountCell = cell as? AccountTableViewCell else { return cell }

        if indexPath.section == 0 {
            if let id = savaData.myInfo?.ownAccount,
               let data = savaData.myShareAccount[id] {
                accountCell.accountNameLable.text = data.name
                accountCell.accountIconImageView.image = UIImage(named: data.iconName)
            }
        } else {
            if let id = savaData.myInfo?.shareAccount[indexPath.row],
               let data = savaData.myShareAccount[id]
            {
                accountCell.accountNameLable.text = data.name
                accountCell.accountIconImageView.image = UIImage(named: data.iconName)
            }
        }

        // 判斷是否為當前選中的 cell
        if indexPath == selectedIndexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        accountCell.checkmarkImageView.isHidden = true
        return accountCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消先前選中的 cell 的勾勾
        if let selectedIndexPath = selectedIndexPath {
            guard let previousSelectedCell = tableView.cellForRow(at: selectedIndexPath) as? AccountTableViewCell else { return }
            previousSelectedCell.checkmarkImageView.isHidden = true
        }

        // 更新當前選中的 indexPath
        selectedIndexPath = indexPath

        // 在選中的 cell 上顯示勾勾
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? AccountTableViewCell else { return }
        if indexPath.section == 0 {
            if let id = savaData.myInfo?.ownAccount {
                accountInfo?(id)
                print(savaData.myShareAccount[id])
            }
        } else {
            if let id = savaData.myInfo?.shareAccount[indexPath.row] {
                accountInfo?(id)
                print(savaData.myShareAccount[id])
            }
        }
        selectedCell.checkmarkImageView.isHidden = false
    }

    // 實現此方法以定義向右滑時顯示的編輯動作
    func tableView(_: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 1 {
//            let editAction = UITableViewRowAction(style: .normal, title: "編輯") { _, _ in
//                // 在這裡處理編輯操作
//                self.editItemAt(indexPath: indexPath)
//            }

            let deleteAction = UITableViewRowAction(style: .normal, title: "刪除") { _, _ in
                // 在這裡處理編輯操作
                self.deleteMessage(indexPath: indexPath)
            }
            deleteAction.backgroundColor = .red
            // 可以新增更多的編輯動作

//            return [editAction, deleteAction]
            return [deleteAction]
        }
        return nil
    }

    // 實作編輯操作的方法
    func editItemAt(indexPath _: IndexPath) {
        // 在這裡處理編輯操作
        // 例如，彈出一個編輯視窗或導航到編輯畫面
        print("編輯 ")
//        if let id = savaData.myInfo?.shareAccount[indexPath.row],
//           let data = savaData.myShareAccount[id] {
//
//        }
    }

    func deleteMessage(indexPath: IndexPath) {
        print("刪除")
        if let id = savaData.myInfo?.shareAccount[indexPath.row] {
            FirebaseManager.postLeaveAccout(userID: savaData.myID, accountId: id) { result in
                switch result {
                case let .success(success):
                    LKProgressHUD.showSuccess(text: success)
                    self.table.reloadData()
                case let .failure(failure):
                    print(failure)
                    LKProgressHUD.showFailure()
                }
            }
        }
    }
}
