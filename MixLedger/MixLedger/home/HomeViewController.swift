//
//  HomeViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/14.
//

import SnapKit
import UIKit

class HomeViewController: UIViewController {
    let saveData = SaveData.shared
    let firebaseManager = FirebaseManager.shared

    var currentAccountID: String = "" {
        didSet {
            if currentAccountID != "" {
                checkNowAccount()
                firebaseManager.addAccountListener(accountID: currentAccountID) { result in
                    switch result {
                    case let .success(accountData):
//                        print("getData Success: \(data)")
                        print("\(String(describing: self.saveData.accountData?.transactions))")

                        var userID: [String] = []
                        if let shareUsersID = accountData.shareUsersID {
                            for user in shareUsersID {
                                for id in user.keys {
                                    userID.append(id)
                                }
                            }
                        }

                        self.billStatusOpenView.usersInfo = []
                        self.saveData.userInfoData = []
                        self.firebaseManager.getUsreInfo(userID: userID) { result in
                            switch result {
                            case let .success(userData):
                                self.billStatusOpenView.usersInfo = userData
                                self.saveData.userInfoData = userData
                                DispatchQueue.main.async {
                                    self.billStatusOpenView.usersInfo = self.saveData.userInfoData
                                    self.billStatusOpenView.billStatus = self.savaData.accountData?.shareUsersID
                                    self.billStatusOpenView.table.reloadData()

                                    self.navigationItem.title = self.saveData.accountData?.accountName
                                    self.billTable.reloadData()
                                }
                            case let .failure(err):
                                print(err)
                            }
                        }
                        self.sum()

                    case let .failure(err):
                        print(err)
                        LKProgressHUD.showFailure(text: "讀取帳本資料失敗")
                    }
                }
            }
        }
    }

    var totla: Double = 0.0
    var expenses: Double = 0.0
    var income: Double = 0.0
    var transactionsDayKeyArr: [String] = []
    var transactionsDayDatasKeys: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = ""
        setupTable()
        getMyOwnAccount()
        setupShareBillView()
        setupLayout()
        setNavigation()
        setupButton()
//        showMonBill()
    }

    override func viewWillAppear(_ result: Bool) {
        super.viewWillAppear(_: result)
    }

    let billStatusSmallView = SharedBillStatusSmallView()
    let billStatusOpenView = SharedBillStatusOpenView()

    let savaData = SaveData.shared

    var selectDate: Date = .init()

    var showView = UIView()
    var billTable = UITableView()
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add"), for: .normal)
        return button
    }()

    func getMyOwnAccount() {
        // find my info
        firebaseManager.getUsreInfo(userID: [savaData.myID]) { result in
            switch result { case let .success(data):
                if data.count != 0 {
                    self.currentAccountID = data[0].ownAccount
                    self.saveData.myInfo = data[0]
                    self.addUserMessageAndAccountListener()
                    LKProgressHUD.showSuccess(text: "成功載入個人資料")
                }
            case .failure:
                LKProgressHUD.showFailure(text: "讀取資料失敗")
            }
        }
    }

    func addUserMessageAndAccountListener() {
        guard let myID = savaData.myInfo?.userID else { return }
        firebaseManager.addUserListener(userID: myID) { result in
            switch result {
            case let .success(data):
                self.savaData.myInfo = data
            case let .failure(err):
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
        accountBookView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(accountBookView, animated: true)
    }

    @objc func shareAccountBook() {
        print("shareAccountBook")
        let shareView = ShareAccountViewController()
        shareView.accountIDWithShare = currentAccountID
        navigationController?.pushViewController(shareView, animated: true)
    }

    func setupShareBillView() {
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

        addRightBarButton()
    }
    
    func addRightBarButton() {
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
    
    func removeRightBarButton() {
        // 移除右邊的按鈕
        navigationItem.rightBarButtonItem = nil
    }

    func setupTable() {
        billTable = UITableView(frame: view.bounds, style: .insetGrouped)
        billTable.layer.cornerRadius = 10
        billTable.backgroundColor = .brightGreen4()
        billTable.delegate = self
        billTable.dataSource = self
        billTable.register(BillTableViewCell.self, forCellReuseIdentifier: "billItemCell")
        billTable.register(BillStatusTableViewCell.self, forCellReuseIdentifier: "billCell")
    }

    func checkNowAccount() {
        if currentAccountID == savaData.myInfo?.ownAccount || savaData.myInfo?.ownAccount == nil {
            showView.isHidden = true
            showView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            removeRightBarButton()
        } else {
            showView.isHidden = false
            showView.snp.updateConstraints { make in
                make.height.equalTo(50)
            }
            closeView()
            addRightBarButton()
        }
    }

    func setupLayout() {
        view.addSubview(showView)
        view.addSubview(billTable)
        view.addSubview(addButton)

        showView.snp.makeConstraints { make in
            make.width.equalTo(view.bounds.size.width * 0.9)
            make.height.equalTo(0)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }

        billTable.snp.makeConstraints { make in
            make.width.equalTo(view.bounds.size.width * 0.9)
            make.centerX.equalTo(view)
            make.top.equalTo(showView.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        addButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.width.height.equalTo(80)
        }
    }

    func reorderTransactionsByDate(transactions: [String]) {
        var convertToDate: [Date] = []

        let dateFont = DateFormatter()
        dateFont.dateFormat = "yyyy-MM-dd"

        for date in transactions {
            guard let dateDate = dateFont.date(from: date) else { return }
            convertToDate.append(dateDate)
        }
        convertToDate.sort { $0 > $1 }
        print(convertToDate)

        transactionsDayKeyArr = []

        for date in convertToDate {
            let dateString = dateFont.string(from: date)
            transactionsDayKeyArr.append(dateString)
        }
    }

    func sum() {
        totla = 0.0
        income = 0.0
        expenses = 0.0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let dateString = dateFormatter.string(from: selectDate)

        guard let datas = savaData.accountData?.transactions?[dateString] else { return }

        for datasKeys in datas.keys {
            guard let data = datas[datasKeys] else { return }
            for dataKey in data.keys {
                guard let transaction = data[dataKey],
                      let mainTypeName = transaction.transactionType?.name else { return }
                let mainType = TransactionMainType(text: mainTypeName)

                if mainType == .expenses {
                    expenses -= abs(transaction.amount)
                    totla -= abs(transaction.amount)
                } else if mainType == .income {
                    income += abs(transaction.amount)
                    totla += abs(transaction.amount)
                }
            }
        }
    }
}

extension HomeViewController: SharedBillStatusSmallViewDelegate, SharedBillStatusOpenViewDelegate, RepayViewDelegate {
    func closeRepayView(subview: RepayView) {
        subview.removeFromSuperview()
    }
    
    func postRepay(payView: UIView, otherUserName: String, otherUserID: String, amount: Double) {
        let mtName = saveData.myInfo?.name ?? ""
        let toOtherUserTest = "\(mtName) 向您還款：\(amount) 請確認收款"
        let toMyselfTest = "您向\(otherUserName) 還款：\(amount)"
        guard let accountData = saveData.accountData else { return }

        firebaseManager.postMessage(toUserID: otherUserID,
                                    textToOtherUser: toOtherUserTest,
                                    textToMyself: toMyselfTest,
                                    isDunningLetter: true,
                                    amount: amount,
                                    fromAccoundID: accountData.accountID,
                                    fromAccoundName: accountData.accountName) { result in
            switch result {
            case .success(let success):
                LKProgressHUD.showSuccess(text: success)
            case .failure(let failure):
                print(failure)
                LKProgressHUD.showFailure()
            }
        }
        payView.removeFromSuperview()
    }

    func addRePayView(subview: RepayView) {
        view.addSubview(subview)
        subview.layer.cornerRadius = 10
        subview.snp.makeConstraints { mark in
            mark.width.equalTo(view.bounds.size.width * 0.8)
            mark.height.equalTo(view.bounds.size.height * 0.4)
            mark.centerX.equalTo(view)
            mark.centerY.equalTo(view)
        }
        subview.delegate = self
    }

    func openView() {
        UIView.animate(withDuration: 0.3) {
            self.showView.snp.updateConstraints { make in
                make.height.equalTo(self.view.bounds.height * 0.57)
            }
            self.billStatusSmallView.removeFromSuperview()
            self.showView.addSubview(self.billStatusOpenView)
            self.billStatusOpenView.snp.makeConstraints { make in
                make.width.equalTo(self.showView)
                make.height.equalTo(self.showView)
                make.centerX.equalTo(self.showView)
                make.centerY.equalTo(self.showView)
            }
            self.view.layoutIfNeeded() 
        }
    }

    func closeView() {
        UIView.animate(withDuration: 0.3) {
            self.showView.snp.updateConstraints { make in
                make.height.equalTo(50)
            }
            self.billStatusOpenView.removeFromSuperview()
            self.showView.addSubview(self.billStatusSmallView)
            self.billStatusSmallView.snp.makeConstraints { make in
                make.width.equalTo(self.showView)
                make.height.equalTo(self.showView)
                make.centerX.equalTo(self.showView)
                make.centerY.equalTo(self.showView)
            }
            self.view.layoutIfNeeded() // 确保立即应用布局变化
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if let datas = saveData.accountData?.transactions?[showMonBill(date: selectDate)]?[transactionsDayKeyArr[section - 1]] {
//
                print("-------datas of numberOfRowsInSelection ------")
                print("\(section)" + "\(datas.keys)")
                return datas.keys.count
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
            reorderTransactionsByDate(transactions: transactionsDayKeyArr)
            return transactionsDayKeyArr[section - 1]
        } else {
            return ""
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        sum()
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath)
            cell.selectionStyle = .none
            guard let billCell = cell as? BillStatusTableViewCell else { return cell }
            billCell.delegate = self
            billCell.showDate = selectDate

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM"
            let dateString = dateFormatter.string(from: selectDate)

            billCell.revenueMoneyLabel.text = MoneyType.money(income).text
            billCell.revenueMoneyLabel.textColor = MoneyType.money(income).color

            billCell.totalMoneyLabel.text = MoneyType.money(totla).text
            billCell.totalMoneyLabel.textColor = MoneyType.money(totla).color

            billCell.payMoneyLabel.text = MoneyType.money(expenses).text
            billCell.payMoneyLabel.textColor = MoneyType.money(expenses).color
            return billCell
        } else {
            let cell = billTable.dequeueReusableCell(withIdentifier: "billItemCell", for: indexPath)
            cell.selectionStyle = .none
            guard let billCell = cell as? BillTableViewCell else { return cell }

            if let datas = saveData.accountData?.transactions?[showMonBill(date: selectDate)]?[transactionsDayKeyArr[indexPath.section - 1]] {
                print(showMonBill(date: selectDate))
//                var transactionsDayDatasKeys: [String] = []
                transactionsDayDatasKeys = []
                for dataKey in datas.keys {
                    transactionsDayDatasKeys.append(dataKey)
                }

                guard let data = datas[transactionsDayDatasKeys[indexPath.row]] else { return cell }
                billCell.sortImageView.image = UIImage(named: data.subType.iconName)


                billCell.titleLabel.text = data.subType.name
                var titleNote = ""

                if let payUser = data.payUser {
                    for key in payUser.keys {
                        if let userName = savaData.userInfoData.first(where: { $0.userID == key })?.name {
                            titleNote += "\(userName)/"
                        }
                    }
                }
                billCell.moneyLabel.text = "\(data.amount)"
//
            }
            return billCell
        }
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath != IndexPath(row: 0, section: 0) {
            let subTypeVC = DetailedBillViewController()
            subTypeVC.modalPresentationStyle = .automatic
            subTypeVC.modalTransitionStyle = .coverVertical
            subTypeVC.sheetPresentationController?.detents = [.custom(resolver: { context in
                context.maximumDetentValue * 0.5
            }
            )]
            if let datas = saveData.accountData?.transactions?[showMonBill(date: selectDate)]?[transactionsDayKeyArr[indexPath.section - 1]] {
                print(showMonBill(date: selectDate))
                transactionsDayDatasKeys = []
                for dataKey in datas.keys {
                    transactionsDayDatasKeys.append(dataKey)
                }

                guard let data = datas[transactionsDayDatasKeys[indexPath.row]] else { return }
                subTypeVC.data = data
                subTypeVC.tableView.reloadData()
            }
            

            present(subTypeVC, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: BillStatusTableViewCellDelegate {
    func changeMonth(cell _: BillStatusTableViewCell, date: Date) {
        selectDate = date
        billTable.reloadData()
    }
}
