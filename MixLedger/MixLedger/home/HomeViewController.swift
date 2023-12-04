//
//  HomeViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/14.
//

import SnapKit
import UIKit

class HomeViewController: UIViewController{
    
    
//    var userID = ["QJeplpxVXBca5xhXWgbT", "qmgOOutGItrZyzKqQOrh", "bGzuwR00sPRNmBamK91D"]

    let saveData = SaveData.shared
    let firebaseManager = FirebaseManager.shared
    
    
    var currentAccountID: String = "" {
        didSet {
            if currentAccountID != "" {
                firebaseManager.addAccountListener(accountID: currentAccountID){ result in
                    switch result{
                    case .success(let accountData):
//                        print("getData Success: \(data)")
                        print("\(String(describing: self.saveData.accountData?.transactions))")
                        
                        var userID: [String] = []
                        if let shareUsersID = accountData.shareUsersID{
                            for user in shareUsersID{
                                for id in user.keys{
                                    userID.append(id)
                                }
                            }
                        }
                        
                        self.billStatusOpenView.usersInfo = []
                        self.saveData.userInfoData = []
                        self.firebaseManager.getUsreInfo(userID: userID) { result in
                            switch result{
                            case .success(let userData):
                                self.billStatusOpenView.usersInfo = userData
                                self.saveData.userInfoData = userData
                                DispatchQueue.main.async {
                                    self.billStatusOpenView.usersInfo = self.saveData.userInfoData
                                    self.billStatusOpenView.billStatus = self.savaData.accountData?.shareUsersID
                                    self.billStatusOpenView.table.reloadData()
                                    
                                    self.navigationItem.title = self.saveData.accountData?.accountName
                                    self.billTable.reloadData()
                                }
                            case .failure(let err):
                                print(err)
                            }
                        }
                        
                        
                    case .failure(let err):
                        print(err)
                        LKProgressHUD.showFailure(text: "讀取帳本資料失敗")
                    }
                }
//                firebaseManager.getData(accountID: currentAccountID) { result in
//                    switch result {
//                    case let .success(data):
//                        // 成功時的處理，data 是一個 Any 類型，你可以根據實際情況轉換為你需要的類型
//                        print("getData Success: \(data)")
//                        print("\(String(describing: self.saveData.accountData?.transactions))")
//                        self.billStatusOpenView.usersInfo = self.saveData.userInfoData
//                        self.billStatusOpenView.billStatus = self.savaData.accountData?.shareUsersID
//                        self.billStatusOpenView.table.reloadData()
//
//                        self.navigationItem.title = self.saveData.accountData?.accountName
//                        self.billTable.reloadData()
//                    case let .failure(error):
//                        // 失敗時的處理
//                        print("Failure: \(error)")
//                    }
//                }
            }
//            if currentAccountID == savaData.myInfo?.ownAccount{
//                showView?.isHidden = true
//                showView?.snp.makeConstraints{(mark) in
//                    mark.height.equalTo(0)
//                }
//            }else{
//                showView?.snp.makeConstraints{(mark) in
//                    mark.height.equalTo(150)
//                }
//                showView?.isHidden = false
//
//            }
        }
    }

    var transactionsDayKeyArr: [String] = []
    var transactionsDayDatasKeys: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = ""
        getMyOwnAccount()
        setupShareBillView()
        setupLayout()
        setupTable()
        setNavigation()
        setupButton()
//        showMonBill()
        
    }

    override func viewWillAppear(_: Bool) {
//        if currentAccountID != "" {
            
//            firebaseManager.getData(accountID: currentAccountID) { result in
//                switch result {
//                case let .success(data):
//                    // 成功時的處理，data 是一個 Any 類型，你可以根據實際情況轉換為你需要的類型
//                    print("getData Success: \(data)")
//                    print("\(String(describing: self.saveData.accountData?.transactions))")
//                    //                guard let data = saveData.accountData?.transactions["2023-11"]?[transactionsMonKeyArr[indexPath.section - 1]] else {return ""}
//                    self.billTable.reloadData()
//                    self.billStatusOpenView.table.reloadData()
//
//                    self.navigationItem.title = self.saveData.accountData?.accountName
//                case let .failure(error):
//                    // 失敗時的處理
//                    print("Failure: \(error)")
//                }
//            }
//        }

//        saveData.userInfoData = [:]
//        billStatusOpenView.usersInfo = [:]
//        if let accountData = savaData.accountData?.shareUsersID {
//            var userID: [String] = []
//            for user in accountData {
//                for key in user.keys {
//                    userID.append(key)
//                }
//            }
//            if !userID.isEmpty {
//                // find friend
//                firebaseManager.findUser(userID: userID) { result in
//
//                    switch result {
//                    case let .success(data):
//                        // 成功時的處理，data 是一個 Any 類型，你可以根據實際情況轉換為你需要的類型
//                        print("findUser Success: \(data)")
//                        var id: [String] = []
//                        for key in data.keys {
//                            id.append(key)
//                            self.saveData.userInfoData[key] = data[key]
//                        }
//                        //                self.saveData.userInfoData[(data.keys as? String) ?? ""] = data[(data.keys as? String) ?? ""]
//                        print("-----find User decode------")
//                        print("\(self.saveData.userInfoData)")
//
//                        self.billStatusOpenView.usersInfo = self.saveData.userInfoData
//                        self.billStatusOpenView.billStatus = self.savaData.accountData?.shareUsersID
//
//                        self.billStatusOpenView.table.reloadData()
//                    case let .failure(error):
//                        // 失敗時的處理
//                        print("Failure: \(error)")
//                    }
//                }
//            }
//        }
    }

    let billStatusSmallView = SharedBillStatusSmallView()
    let billStatusOpenView = SharedBillStatusOpenView()

    let savaData = SaveData.shared

    var selectDate: Date = .init()

    var showView = UIView()
    let billTable = UITableView()
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add"), for: .normal)
        return button
    }()

    func getMyOwnAccount() {
        // find my info
        firebaseManager.getUsreInfo(userID: [savaData.myID]){result in
            switch result{case .success(let data):
                if data.count != 0{
                    self.currentAccountID = data[0].ownAccount
                    self.saveData.myInfo = data[0]
                    self.addUserMessageListener()
                    LKProgressHUD.showSuccess(text: "成功載入個人資料")
                }
            case .failure(_):
                LKProgressHUD.showFailure(text: "讀取資料失敗")
            }
        }
    }
    
    func addUserMessageListener(){
        guard let myID = savaData.myInfo?.userID else {return}
        firebaseManager.addUserMessageListener(userID: myID){result in
            switch result{
            case .success(let data):
                self.savaData.myInfo?.message = data.message
                LKProgressHUD.showSuccess(text: "成功載入個人訊息")
            case .failure(let err):
                print(err)
            }
        }
    }

    func showMonBill(date: Date) -> String {
        let dateFont = DateFormatter()
        dateFont.dateFormat = "yyyy-MM"
        let selectDateString = dateFont.string(from: date)
        return selectDateString
    }

    func setupButton() {
        addButton.addTarget(self, action: #selector(addNewBill), for: .touchUpInside)
    }
    

    @objc func addNewBill() {
        print("addNewBill")
        let addNewView = AddNewItemViewController()
        addNewView.currentAccountID = currentAccountID
        present(addNewView, animated: true)
    }

    @objc func editAccountBook() {
        let accountBookView = AllAccountBookViewController()
        accountBookView.accountInfo = { currentAccountID in
            print("\(currentAccountID)")
            self.currentAccountID = currentAccountID
        }
        navigationController?.pushViewController(accountBookView, animated: true)
    }

    @objc func shareAccountBook() {
        print("shareAccountBook")
        let searchView = SearchAllUserViewController()
        searchView.accountIDWithShare = currentAccountID
        navigationController?.pushViewController(searchView, animated: true)
    }

    func setupShareBillView() {
        openView()

        billStatusSmallView.layer.cornerRadius = 10
        billStatusOpenView.layer.cornerRadius = 10
        billStatusSmallView.smallDelegate = self
        billStatusOpenView.openDelegate = self
    }

    func setNavigation() {
        // 導覽列左邊按鈕
        let editAccountBookButton = UIBarButtonItem(
            image: UIImage(named: "storytelling")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(editAccountBook)
        )
        // 加到導覽列中
        navigationItem.leftBarButtonItem = editAccountBookButton

        // 導覽列右邊按鈕
        let shareButton = UIBarButtonItem(
            //          title:"設定",
            image: UIImage(named: "share")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(shareAccountBook)
        )
        // 加到導覽列中
        navigationItem.rightBarButtonItem = shareButton
    }

    func setupTable() {
        billTable.layer.cornerRadius = 10
        billTable.delegate = self
        billTable.dataSource = self
        billTable.register(BillTableViewCell.self, forCellReuseIdentifier: "billItemCell")
        billTable.register(BillStatusTableViewCell.self, forCellReuseIdentifier: "billCell")
    }

    func setupLayout() {
        view.addSubview(showView)
        view.addSubview(billTable)
        view.addSubview(addButton)
        showView.snp.makeConstraints { make in
            make.width.equalTo(view.bounds.size.width * 0.9)
            make.height.equalTo(150)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(3)
        }

        billTable.snp.makeConstraints { make in
            make.width.equalTo(view.bounds.size.width * 0.9)
            make.centerX.equalTo(view)
            make.top.equalTo(showView.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
//                make.width.equalTo(view.safeAreaLayoutGuide)
        }

        addButton.snp.makeConstraints { make in

            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.width.height.equalTo(80)
        }
    }

    // struct billItem{
    // }
    func reorderTransactionsByDate(transactions: [String]){
        var convertToDate: [Date] = []
        
        let dateFont = DateFormatter()
        dateFont.dateFormat = "yyyy-MM-dd"
        
        for date in transactions {
            guard let dateDate = dateFont.date(from: date) else {return}
            convertToDate.append(dateDate)
        }
        convertToDate.sort{ $0 > $1 }
        print(convertToDate)
        
        transactionsDayKeyArr = []
        
        for date in convertToDate {
            let dateString = dateFont.string(from: date)
            transactionsDayKeyArr.append(dateString)
        }
    }
}

extension HomeViewController: SharedBillStatusSmallViewDelegate, SharedBillStatusOpenViewDelegate, RepayViewDelegate {
    func postRepay(payView: UIView, otherUserName: String, otherUserID: String, amount: Double) {
        let mtName = saveData.myInfo?.name ?? ""
        let toOtherUserTest = "\(mtName) 向您還款：\(amount) 請確認收款"
        let toMyselfTest = "您向\(otherUserName) 還款：\(amount)"
        guard let accountData = saveData.accountData else {return}
        
        firebaseManager.postMessage(toUserID: otherUserID, 
                                    textToOtherUser: toOtherUserTest,
                                    textToMyself: toMyselfTest,
                                    isDunningLetter: true,
                                    amount: amount,
                                    fromAccoundID: accountData.accountID,
                                    fromAccoundName: accountData.accountName){ _ in
            return
        }
        
        payView.removeFromSuperview()
    }
    
    func addRePayView(subview: RepayView) {
        view.addSubview(subview)
        subview.layer.cornerRadius = 10
        subview.snp.makeConstraints{(mark) in
            mark.width.equalTo(view.bounds.size.width * 0.8)
            mark.height.equalTo(view.bounds.size.height * 0.4)
            mark.centerX.equalTo(view)
            mark.centerY.equalTo(view)
        }
        subview.delegate = self
    }
   
    func openView() {
        billStatusSmallView.removeFromSuperview()
        showView.snp.updateConstraints { mark in
            mark.height.equalTo(150)
        }
        showView.addSubview(billStatusOpenView)
        billStatusOpenView.snp.makeConstraints { mark in
            mark.width.equalTo(showView)
            mark.height.equalTo(showView)
            mark.centerX.equalTo(showView)
            mark.centerY.equalTo(showView)
        }
    }

    func closeView() {
        billStatusOpenView.removeFromSuperview()

        showView.snp.updateConstraints { mark in
            mark.height.equalTo(50)
        }
        showView.addSubview(billStatusSmallView)
        billStatusSmallView.snp.makeConstraints { mark in
            mark.width.equalTo(showView)
            mark.height.equalTo(showView)
            mark.centerX.equalTo(showView)
            mark.centerY.equalTo(showView)
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
//            let bill = billArray[section - 1]
            if let datas = saveData.accountData?.transactions?[showMonBill(date: selectDate)]?[transactionsDayKeyArr[section - 1]] {
//
//
//                for dataKey in datas.keys{
//                    transactionsDayDatasKeys.append(dataKey)
//                }
//                datas[]
                print("-------datas of numberOfRowsInSelection ------")
                print("\(section)" + "\(datas.keys)")
                return datas.keys.count
//                guard let data = datas[transactionsDayDatasKeys[indexPath]] else { return cell }
            }
            return 0
        }
    }

    func numberOfSections(in _: UITableView) -> Int {
        guard var number = saveData.accountData?.transactions?[showMonBill(date: selectDate)]?.keys.count else { return 1 }
        number += 1
        return number
    }

    func tableView(tableView _: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0 {
            return 00
        } else {
            return 80
        }
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let data = saveData.accountData?.transactions?[showMonBill(date: selectDate)] else { return "" }
        transactionsDayKeyArr = []
        for key in data.keys {
            transactionsDayKeyArr.append(key)
        }
        if section != 0 {
//            guard let date = billArray[section - 1]["日期"]?[0] as? Date else{ return ""}
//            let dateString = dateFont.string(from: date)
            ////            print(dateString)
//            return dateString
//            guard transactionsDayKeyArr.count >= section  else { return "" }
            reorderTransactionsByDate(transactions: transactionsDayKeyArr)
            return transactionsDayKeyArr[section - 1]
        } else {
            return ""
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath)
            guard let billCell = cell as? BillStatusTableViewCell else { return cell }
            billCell.delegate = self
            billCell.showDate = selectDate
            billCell.revenueMoneyLabel.text = MoneyType.money(saveData.accountData?.accountInfo.income ?? 0).text
            billCell.revenueMoneyLabel.textColor = MoneyType.money(saveData.accountData?.accountInfo.income ?? 0).color

            billCell.totalMoneyLabel.text = MoneyType.money(saveData.accountData?.accountInfo.total ?? 0).text
            billCell.totalMoneyLabel.textColor = MoneyType.money(saveData.accountData?.accountInfo.total ?? 0).color

            billCell.payMoneyLabel.text = MoneyType.money(saveData.accountData?.accountInfo.expense ?? 0).text
            billCell.payMoneyLabel.textColor = MoneyType.money(saveData.accountData?.accountInfo.expense ?? 0).color
            return cell
        } else {
            let cell = billTable.dequeueReusableCell(withIdentifier: "billItemCell", for: indexPath)
            guard let billCell = cell as? BillTableViewCell else { return cell }

            if let datas = saveData.accountData?.transactions?[showMonBill(date: selectDate)]?[transactionsDayKeyArr[indexPath.section - 1]] {
//                print("-------------data.keys--------")
//                print(transactionsDayKeyArr[indexPath.section - 1])
                print(showMonBill(date: selectDate))
//                var transactionsDayDatasKeys: [String] = []
                transactionsDayDatasKeys = []
                for dataKey in datas.keys {
                    transactionsDayDatasKeys.append(dataKey)
                }

                guard let data = datas[transactionsDayDatasKeys[indexPath.row]] else { return cell }
//                if let iconName = data.type.iconName {
                billCell.sortImageView.image = UIImage(named: data.subType.iconName)
//                }

                billCell.titleLabel.text = data.subType.name
                var titleNote = ""

                
                
                
                if let payUser = data.payUser {
                    for key in payUser.keys {
                        let userName = savaData.userInfoData.first(where: { $0.userID == key })?.name
                        titleNote += "\(userName)/"
                    }
                }
                if titleNote == "" {
                    titleNote = data.note ?? ""
                } else {
                    titleNote += "/\(data.note)"
                }
                billCell.titleNoteLabel.text = titleNote
                billCell.moneyLabel.text = "\(data.amount)"
//
            }
            return cell
        }
    }
}

extension HomeViewController: BillStatusTableViewCellDelegate {
    func changeMonth(cell _: BillStatusTableViewCell, date: Date) {
        selectDate = date
        billTable.reloadData()
    }
}
