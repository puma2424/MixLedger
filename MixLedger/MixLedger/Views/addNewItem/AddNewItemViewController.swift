//
//  AddNewItemViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import SnapKit
import UIKit
import Vision

class AddNewItemViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "G3")
        setLayout()
        setTable()
        setCheckButton()
        memberInfo()
        scanInvoiceManager = ScanInvoiceManager(viewController: self)
    }

    var scanInvoiceManager: ScanInvoiceManager?

    var currentAccountID: String = ""

    let saveData = SaveData.shared

    let firebase = FirebaseManager.shared

    var memberPayMoney: [String: Double] = [:] {
        didSet {
            let indexPathToReload = IndexPath(row: 4, section: 0)
            table.reloadRows(at: [indexPathToReload], with: .automatic)
        }
    }

    var memberShareMoney: [String: Double] = [:] {
        didSet {
            let indexPathToReload = IndexPath(row: 5, section: 0)
            table.reloadRows(at: [indexPathToReload], with: .automatic)
        }
    }

    var amount: Double? {
        didSet {
            if amount == nil {
                var keys: [String] = []
                for key in memberPayMoney.keys {
                    keys.append(key)
                    memberShareMoney[key] = 0
                }
                memberPayMoney[keys[0]] = 0
            } else {
                var keys: [String] = []
                for key in memberPayMoney.keys {
                    keys.append(key)
                    let shareMoney = (amount ?? 0) / Double(memberPayMoney.keys.count)
                    let shareMoneyString = String(format: "%.1f", shareMoney)
                    memberShareMoney[key] = Double(shareMoneyString) ?? 0
                }
                memberPayMoney[keys[0]] = amount
            }
        }
    }

    var member: String?

    var selectDate: Date = .init()

    var type: TransactionType?

    let table = UITableView()

    var invoiceString: [String] = []

    var invoiceNumber: String = ""

    var invoiceDate: String = ""

    var invoiceRandomNumber: String = ""

    var invoiceTotalAmount: String = "" {
        didSet {
            amount = Double(invoiceTotalAmount)
        }
    }

    var productDetails: [ProductInfo] = []

    var note: String = ""

    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: AllIcons.close.rawValue), for: .normal)
        return button
    }()

    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "G2")
        return view
    }()

    let checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("確      認", for: .normal)
        button.backgroundColor = .g2()
        button.layer.cornerRadius = 10
        return button
    }()

    func checkButtonColorChange() {
        var paySum = 0.0
        var shareSum = 0.0

        for payID in memberPayMoney.keys {
            paySum += memberPayMoney[payID] ?? 0
        }
        for shareID in memberShareMoney.keys {
            shareSum += memberPayMoney[shareID] ?? 0
        }

        if let amount = amount,
           type != nil,
           paySum == amount,
           shareSum == amount {
            checkButton.backgroundColor = .brightGreen3()
        } else {
            checkButton.backgroundColor = .g2()
        }
    }

    func whyCannotSend() {
        var paySum = 0.0
        var shareSum = 0.0

        for payID in memberPayMoney.keys {
            paySum += memberPayMoney[payID] ?? 0
        }
        for shareID in memberShareMoney.keys {
            shareSum += memberPayMoney[shareID] ?? 0
        }
        
        var titleText: String = "" {
            didSet {
                ShowCustomAlertManager.customAlert(title: titleText,
                                                   message: "",
                                                   vc: self,
                                                   actionHandler: nil)
            }
        }

        if amount == nil {
            titleText = "No amount entered"
        } else if type == nil {
            titleText = "No type selected"
        } else if paySum != amount {
            titleText = "The total amount paid by the payers is inconsistent with the input amount"
        } else if shareSum != amount {
            titleText = "The total amount paid by the sharers is inconsistent with the input amount"
        }
    }
    
    func postDataToAddNewBill(postTransaction: Transaction) {
         
         LKProgressHUD.show()
         firebase.postData(toAccountID: currentAccountID, 
                           transaction: postTransaction,
                           memberPayMoney: memberPayMoney,
                           memberShareMoney: memberShareMoney) { result in
             switch result {
             case let .success(success):
                 print(success)
                 LKProgressHUD.showSuccess()
             case let .failure(failure):
                 print(failure)
                 LKProgressHUD.showFailure()
             }
         }

         var payUsersID: [String] = []
         for userID in memberPayMoney.keys {
             payUsersID.append(userID)
         }

         if let accountName = saveData.accountData?.accountName,
            saveData.accountData?.accountID != saveData.myInfo?.ownAccount {
             let usersInfo = saveData.userInfoData
             firebase.postUpdatePayerAccount(isMyAccount: false,
                                             formAccountName: accountName,
                                             usersInfo: usersInfo,
                                             transaction: postTransaction) { result in
                 switch result {
                 case let .success(success):
                     print(success)
                     LKProgressHUD.showSuccess(text: "同步到支出者帳本")
                 case let .failure(failure):
                     print(failure)
                     LKProgressHUD.showSuccess(text: "無法同步到支出者帳本")
                 }
             }
         }
         
    }

    @objc func checkButtonActive() {
        var paySum = 0.0
        var shareSum = 0.0

        for payID in memberPayMoney.keys {
            paySum += memberPayMoney[payID] ?? 0
        }
        for shareID in memberShareMoney.keys {
            shareSum += memberPayMoney[shareID] ?? 0
        }

        if let amount = amount,
           let subType = type,
           paySum == amount,
           shareSum == amount { // 找到對應的字典
            let transactionType = TransactionType(iconName: "", name: TransactionMainType.expenses.text)
            
            let transaction = Transaction(transactionType: transactionType,
                                          amount: -amount,
                                          currency: "新台幣",
                                          date: selectDate,
                                          note: note,
                                          payUser: memberPayMoney,
                                          shareUser: memberShareMoney,
                                          subType: subType)
            postDataToAddNewBill(postTransaction: transaction)
            dismiss(animated: true)
        } else {
            whyCannotSend()
        }
    }

    func setCheckButton() {
        checkButton.addTarget(self, action: #selector(checkButtonActive), for: .touchUpInside)
    }

    func setTable() {
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.register(ANIMoneyTableViewCell.self, forCellReuseIdentifier: "moneyCell")
        table.register(ANITypeTableViewCell.self, forCellReuseIdentifier: "typeCell")
        table.register(ANIInvoiceTableViewCell.self, forCellReuseIdentifier: "invoiceCell")
        table.register(ANIMemberTableViewCell.self, forCellReuseIdentifier: "memberCell")
        table.register(ANISelectDateTableViewCell.self, forCellReuseIdentifier: "dateCell")
    }

    func setLayout() {
        view.addSubview(table)
        view.addSubview(lineView)
        view.addSubview(checkButton)
        view.addSubview(closeButton)

        closeButton.snp.makeConstraints { mark in
            mark.width.height.equalTo(24)
            mark.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            mark.leading.equalTo(view.safeAreaLayoutGuide).offset(12)
        }

        lineView.snp.makeConstraints { mark in
            mark.height.equalTo(1)
            mark.width.equalTo(view.bounds.size.width * 0.9)
            mark.top.equalTo(closeButton.snp.bottom).offset(12)
            mark.centerX.equalTo(view)
        }

        checkButton.snp.makeConstraints { mark in
            mark.width.equalTo(view.bounds.size.width * 0.8)
            mark.height.equalTo(50)
            mark.centerX.equalTo(view)
            mark.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }

        table.snp.makeConstraints { mark in
            mark.top.equalTo(lineView.snp.bottom)
            mark.leading.equalTo(view)
            mark.bottom.equalTo(checkButton.snp.top)
            mark.trailing.equalTo(view)
        }
    }

    func memberInfo() {
        if saveData.userInfoData.count != 0 {
            for user in saveData.userInfoData {
                memberPayMoney[user.userID] = 0
                memberShareMoney[user.userID] = 0
            }
        }
    }
    
    func moneyCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moneyCell", for: indexPath)
        cell.selectionStyle = .none
        guard let moneyCell = cell as? ANIMoneyTableViewCell else { return cell }
        moneyCell.iconImageView.image = UIImage(named: AllIcons.moneyAndCoin.rawValue)

        let amountString = String(format: "%.2f", amount ?? 0.0)
        moneyCell.inputTextField.text = amountString

        moneyCell.inputTextField.addTarget(self, action: #selector(getAmount(_:)), for: .editingChanged)
        return moneyCell
    }
    
    func typeCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath)
        cell.selectionStyle = .none
        guard let typeCell = cell as? ANITypeTableViewCell else { return cell }
        return typeCell
    }
    
    func invoiceCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 掃描發票
        let cell = tableView.dequeueReusableCell(withIdentifier: "invoiceCell", for: indexPath)
        cell.selectionStyle = .none
        guard let invoiceCell = cell as? ANIInvoiceTableViewCell else { return cell }
        invoiceCell.invoiceLabel.text = "" 
        var text = ""
        if invoiceNumber != "" {
            text = "發票號碼： \(invoiceNumber)"
        }
        if invoiceDate != "" {
            text += "\n購買日期：\(invoiceDate)"
        }
        if invoiceRandomNumber != "" {
            text += "\n隨機碼：\(invoiceRandomNumber)"
        }
        if invoiceTotalAmount != "" {
            text += "\n金額：\(invoiceTotalAmount)"
        }
        print(productDetails)
        for product in productDetails {
            text += "\n商品： \(product.name) \(product.price) * \(product.quantity)"
        }
        invoiceCell.invoiceLabel.text = text
        note = text
        if text != "" {
            invoiceCell.resetLayout()
        }
        return invoiceCell
    }
    
    func dateCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
        cell.selectionStyle = .none
        guard let dateCell = cell as? ANISelectDateTableViewCell else { return cell }
        dateCell.datePicker.date = selectDate
        dateCell.datePicker.addTarget(self, action: #selector(datePickerDidChange(_:)), for: .valueChanged)
        return dateCell
    }
    
    func memberCell(tableView: UITableView,
                    cellForRowAt indexPath: IndexPath,
                    title: String,
                    usersMoney: [String: Double]?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        cell.selectionStyle = .none
        guard let memberShareCell = cell as? ANIMemberTableViewCell else { return cell }
        memberShareCell.showTitleLabel.text = title
        memberShareCell.usersMoney = usersMoney
        return memberShareCell
    }

}

extension AddNewItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch indexPath.row {
            case 0:
                cell = moneyCell(tableView: tableView, cellForRowAt: indexPath)
            case 1:
                cell = typeCell(tableView: tableView, cellForRowAt: indexPath)
            case 2:
                cell = invoiceCell(tableView: tableView, cellForRowAt: indexPath)
            case 3:
                cell = dateCell(tableView: tableView, cellForRowAt: indexPath)
            case 4:
                cell = memberCell(tableView: tableView, 
                                  cellForRowAt: indexPath,
                                  title: "付款",
                                  usersMoney: memberPayMoney)
            default:
                cell = memberCell(tableView: tableView, 
                                  cellForRowAt: indexPath,
                                  title: "分款",
                                  usersMoney: memberShareMoney)
            }
        return cell
     
    }

    @objc func getAmount(_ textField: UITextField) {
        amount = Double(textField.text ?? "0.0")
        checkButtonColorChange()
    }

    @objc func datePickerDidChange(_ datePicker: UIDatePicker) { // DatePicker 的值變化時的動作
        selectDate = datePicker.date
        print(selectDate)
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let subTypeVC = SelectIconViewController(iconGroup: SelectIconManager().subTypeGroup)
            subTypeVC.modalPresentationStyle = .automatic
            subTypeVC.modalTransitionStyle = .coverVertical
            subTypeVC.sheetPresentationController?.detents = [.custom(resolver: { context in
                context.maximumDetentValue * 0.5
            })]
            subTypeVC.selectedSubType = { iconName, title in
                self.type = TransactionType(iconName: iconName, name: title)
                if subTypeVC.selectedIndex != nil {
                    let cell = self.table.cellForRow(at: IndexPath(row: 1, section: 0)) as? ANITypeTableViewCell
                    cell?.iconImageView.image = UIImage(named: iconName)
                    cell?.titleLabel.text = title
                }
                self.checkButtonColorChange()
            }
            present(subTypeVC, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            scanInvoiceManager?.imagePicker.delegate = self
            scanInvoiceManager?.selectPhotoButtonTapped()
        } else if indexPath.row == 4 {
            let selectMemberView = SelectMemberViewController()
            selectMemberView.usersMoney = memberPayMoney
            selectMemberView.delegate = self
            selectMemberView.payOrShare = .pay
            present(selectMemberView, animated: true)
        } else if indexPath.row == 5 {
            let selectMemberView = SelectMemberViewController()
            selectMemberView.usersMoney = memberShareMoney
            selectMemberView.delegate = self
            selectMemberView.payOrShare = .share
            present(selectMemberView, animated: true)
        }
    }
}

extension AddNewItemViewController: SelectMemberViewControllerDelegate {
    func inputPayMemberMoney(cell: SelectMemberViewController) {
        memberPayMoney = cell.usersMoney ?? memberPayMoney
        print(memberPayMoney)
        table.reloadData()
        checkButtonColorChange()
    }

    func inputShareMemberMoney(cell: SelectMemberViewController) {
        memberShareMoney = cell.usersMoney ?? memberPayMoney
        print(memberShareMoney)
        table.reloadData()
        checkButtonColorChange()
    }
}

extension AddNewItemViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_: UIImagePickerController, 
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            LKProgressHUD.show(inView: view)
            scanInvoiceManager?.displayBarcodeResults(selectedImage: selectedImage) { results in
                switch results {
                case let .success(result):
                    switch result {
                    case .formQRCode:
                        guard let scanInvoiceManager = self.scanInvoiceManager else {
                            return LKProgressHUD.showFailure(inView: self.view)
                        }
                        self.invoiceNumber = scanInvoiceManager.invoiceNumber
                        self.invoiceDate = scanInvoiceManager.invoiceDateString
                        self.selectDate = scanInvoiceManager.invoiceDate
                        self.invoiceRandomNumber = scanInvoiceManager.invoiceRandomNumber
                        self.invoiceTotalAmount = scanInvoiceManager.invoiceTotalAmount
                        self.productDetails = scanInvoiceManager.productDetails
                    }
                    LKProgressHUD.showSuccess(inView: self.view)
                    self.table.reloadData()

                case .failure:
                    LKProgressHUD.showFailure(inView: self.view)
                    return
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
