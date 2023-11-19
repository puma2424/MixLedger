//
//  ViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/14.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController{
    
    var userID = ["QJeplpxVXBca5xhXWgbT", "qmgOOutGItrZyzKqQOrh"]
    
    let saveData = SaveData.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "我的帳本"
        setupShareBillView()
        setupLayout()
        setupTable()
        setNavigation()
        setupButton()
        
        let firebaseManager = FirebaseManager.shared
        firebaseManager.getData()
        firebaseManager.findUser(userID: userID)
        
    }
    
    let billStatusSmallView = SharedBillStatusSmallView()
    let billStatusOpenView = SharedBillStatusOpenView()
    var showView: UIView?
    let billTable = UITableView()
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add"), for: .normal)
        return button
    }()
    
    func setupButton(){
        addButton.addTarget(self, action: #selector(addNewBill), for: .touchUpInside)
    }
    @objc func addNewBill(){
        print("addNewBill")
        let addNewView = AddNewItemViewController()
        present(addNewView, animated: true)
    }
    @objc func editAccountBook(){
        let accountBookView = AllAccountBookViewController()
        accountBookView.accountInfo = { info in
            print("\(info)")
            return
        }
        navigationController?.pushViewController(accountBookView, animated: true)
        
    }
    @objc func shareAccountBook(){
        print("shareAccountBook")
    }
    func setupShareBillView(){
        showView = billStatusOpenView
        billStatusSmallView.layer.cornerRadius = 10
        billStatusOpenView.layer.cornerRadius = 10
        billStatusSmallView.smallDelegate = self
        billStatusOpenView.openDelegate = self
    }
    
    func setNavigation(){
        // 導覽列左邊按鈕
        let editAccountBookButton = UIBarButtonItem(
            image: UIImage(named:"storytelling")?.withRenderingMode(.alwaysOriginal),
          style:.plain ,
          target:self ,
          action: #selector(editAccountBook))
        // 加到導覽列中
        self.navigationItem.leftBarButtonItem = editAccountBookButton

        // 導覽列右邊按鈕
        let shareButton = UIBarButtonItem(
//          title:"設定",
            image: UIImage(named:"share")?.withRenderingMode(.alwaysOriginal),
          style:.plain,
          target:self,
          action:#selector(shareAccountBook))
        // 加到導覽列中
        self.navigationItem.rightBarButtonItem = shareButton
    }
    
    func setupTable(){
        billTable.delegate = self
        billTable.dataSource = self
        billTable.register(BillTableViewCell.self, forCellReuseIdentifier: "billItemCell")
        billTable.register(BillStatusTableViewCell.self, forCellReuseIdentifier: "billCell")
    }
    
    func setupLayout(){
        if let showView = showView{
            view.addSubview(showView)
            view.addSubview(billTable)
            view.addSubview(addButton)
            showView.snp.makeConstraints{(make) in
                make.width.equalTo(view.bounds.size.width * 0.9)
                make.height.equalTo(150)
                make.centerX.equalTo(view)
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(3)
            }
            
            billTable.snp.makeConstraints{(make) in
                make.width.equalTo(view.bounds.size.width * 0.9)
                make.centerX.equalTo(view)
                make.top.equalTo(showView.snp.bottom).offset(10)
                make.bottom.equalTo(view.safeAreaLayoutGuide)
//                make.width.equalTo(view.safeAreaLayoutGuide)
            }
            
            addButton.snp.makeConstraints{(make) in
                
                make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
                make.width.height.equalTo(80)
            }
        }
        
        
    }
    
    
    //struct billItem{
    //}
    
}

extension HomeViewController: SharedBillStatusSmallViewDelegate, SharedBillStatusOpenViewDelegate{
    func inputData(view: SharedBillStatusOpenView) {
        view.usersInfo = saveData.userInfoData
        print(view.usersInfo)
    }
   
    
    
    func openView() {
////        showView = nil
//        showView?.snp.updateConstraints{(mark) in
//            mark.height.equalTo(300)
//        }
//        showView = billStatusOpenView
//        // 顯式告訴視圖重新佈局
//            self.view.layoutIfNeeded()
//       
//        
    }
    func closeView() {
//        showView?.snp.updateConstraints{(mark) in
//            mark.height.equalTo(100)
//        }
//        showView = billStatusSmallView
//
//        // 顯式告訴視圖重新佈局
//            self.view.layoutIfNeeded()
        
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            let bill = billArray[section - 1]
            return bill["item"]?.count ?? 0
        }
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return billArray.count + 1
    }
    func tableView(tableView: UITableView,
      heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 00
        }else{
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFont = DateFormatter()
        dateFont.dateFormat = "yyyy-MM-dd"
        if section != 0{
            guard let date = billArray[section - 1]["日期"]?[0] as? Date else{ return ""}
            let dateString = dateFont.string(from: date)
//            print(dateString)
            return dateString
        }else{
            return ""
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = billTable.dequeueReusableCell(withIdentifier: "billCell", for: indexPath)
            guard let billCell = cell as? BillStatusTableViewCell else { return cell }
            return cell
        }else{
            let cell = billTable.dequeueReusableCell(withIdentifier: "billItemCell", for: indexPath)
            
            guard let billCell = cell as? BillTableViewCell else { return cell }
            
            let datas = billArray[indexPath.row]["item"]
            
            if let data = datas?[indexPath.row] as? [String: Any] {
                if let money = data["金額"] as? Int {
                    let moneyType: MoneyType = .money(Double(money))
                    billCell.moneyLabel.text = moneyType.text
                    billCell.moneyLabel.textColor = moneyType.color
                }
                if let moneyNote = data["幣別"] as? String {
                    billCell.moneyNoteLabel.text = moneyNote
                }
                if let title = data["類型"] as? BillTag {
                    billCell.titleLabel.text = title.name
                    billCell.sortImageView.image = UIImage(named: title.iconName)
                }
                if let titleNote = data["備註"] as? String , let pay = data["付費者"] as? [String]{
                    var note = ""
                    pay.forEach{note += "\($0) "}
                    note += "/\(titleNote)"
                    billCell.titleNoteLabel.text = note
                }
                
            }
            return cell
        }
        
//        return cell
    }
}
