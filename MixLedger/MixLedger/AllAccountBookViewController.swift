//
//  AllAccountBookViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import UIKit
import SnapKit
class AllAccountBookViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setTable()
        setLayout()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    var accountInfo: ((Any) -> ())?
    let table = UITableView()
    var selectedIndexPath: IndexPath?
    func setTable(){
        table.delegate = self
        table.dataSource = self
        table.register(AccountTableViewCell.self, forCellReuseIdentifier: "accountCell")
    }
    
    
    @objc func backHome(){
        print("editAccountBook")
        navigationController?.popToRootViewController(animated: true)
    }
    @objc func addNewAccount(){
        print("shareAccountBook")
    }
    
    func setLayout(){
        view.addSubview(table)
        table.snp.makeConstraints{(mark) in
            mark.top.equalTo(view.safeAreaLayoutGuide)
            mark.leading.equalTo(view.safeAreaLayoutGuide)
            mark.bottom.leading.equalTo(view.safeAreaLayoutGuide)
            mark.trailing.leading.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setNavigation(){
        // 導覽列左邊按鈕
        let backHomeButton = UIBarButtonItem(
            image: UIImage(named:AllIcons.icons8Back.rawValue)?.withRenderingMode(.alwaysOriginal),
          style:.plain ,
          target:self ,
          action: #selector(backHome))
        // 加到導覽列中
        self.navigationItem.leftBarButtonItem = backHomeButton

        // 導覽列右邊按鈕
        let addNewAccount = UIBarButtonItem(
//          title:"設定",
            image: UIImage(named:AllIcons.add2.rawValue)?.withRenderingMode(.alwaysOriginal),
          style:.plain,
          target:self,
          action:#selector(addNewAccount))
        // 加到導覽列中
        self.navigationItem.rightBarButtonItem = addNewAccount
    }
    
}

extension AllAccountBookViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allAccount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath)
        guard let accountCell = cell as? AccountTableViewCell else{ return cell }
        // 判斷是否為當前選中的 cell
        if indexPath == selectedIndexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        let data = allAccount[indexPath.row]
        if let name = data["name"] as? String{
            accountCell.accountNameLable.text = name
        }
        
        if let iconName = data["iconName"] as? String{
            accountCell.accountIconImageView.image = UIImage(named: iconName)
        }
        accountCell.checkmarkImageView.isHidden = true
        return accountCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消先前選中的 cell 的勾勾
               if let selectedIndexPath = selectedIndexPath {
                   guard let previousSelectedCell = tableView.cellForRow(at: selectedIndexPath) as? AccountTableViewCell else {return}
                   previousSelectedCell.checkmarkImageView.isHidden = true
               }

               // 更新當前選中的 indexPath
               selectedIndexPath = indexPath

               // 在選中的 cell 上顯示勾勾
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? AccountTableViewCell else {return}
        accountInfo?(allAccount[indexPath.row])
        selectedCell.checkmarkImageView.isHidden = false
    }
    
}
