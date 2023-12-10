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
        NotificationCenter.default.addObserver(self, selector: #selector(handleAccountNotification), name: .myMessageNotification, object: nil)
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
    
    @objc func handleAccountNotification(){
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
            var allAccount: [String] = myAccount + shareAccount
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_: UITableView, numberOfRowsInSection numberOfRowsInSection: Int) -> Int {
        guard let data = savaData.myInfo else { return 0 }
        if numberOfRowsInSection == 0{
            return 1
        }else {
            return data.shareAccount.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "My Account"
        }else{
            return "Share Account"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath)
        cell.backgroundColor = .brightGreen4()
        guard let accountCell = cell as? AccountTableViewCell else { return cell }

        if indexPath.section == 0 {
            if let id = savaData.myInfo?.ownAccount {
                accountCell.accountNameLable.text = savaData.myShareAccount[id]
            }
        } else {
            if let id = savaData.myInfo?.shareAccount[indexPath.row] {
                accountCell.accountNameLable.text = savaData.myShareAccount[id]
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
}
