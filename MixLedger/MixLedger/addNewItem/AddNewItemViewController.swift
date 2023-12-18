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
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    let scanInvoiceManager = ScanInvoiceManager.shared

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
                    memberShareMoney[key] = Double(String(format: "%.1f", (amount ?? 0) / Double(memberPayMoney.keys.count))) ?? 0
                }
                memberPayMoney[keys[0]] = amount
            }
        }
    }

    var member: String?

    var selectDate: Date = .init()

    var type: TransactionType?

    let table = UITableView()

    let imagePicker = UIImagePickerController()

    var invoiceString: [String] = []

    var invoiceNumber: String = ""

    var invoiceDate: String = ""

    var invoiceRandomNumber: String = ""

    var invoiceTotalAmount: String = "" {
        didSet {
            amount = Double(invoiceTotalAmount)
        }
    }

    var invoiceOfChineseEncodingParameter: ChineseEncodingParameter?

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
           let subType = type,
           paySum == amount,
           shareSum == amount
        {
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

        if amount == nil {
            ShowCustomAlertManager.customAlert(title: "No amount entered", message: "", vc: self, actionHandler: nil)
        } else if type == nil {
            ShowCustomAlertManager.customAlert(title: "No type selected", message: "", vc: self, actionHandler: nil)
        } else if paySum != amount {
            ShowCustomAlertManager.customAlert(title: "The total amount paid by the payers is inconsistent with the input amount", message: "", vc: self, actionHandler: nil)
        } else if shareSum != amount {
            ShowCustomAlertManager.customAlert(title: "The total amount paid by the sharers is inconsistent with the input amount", message: "", vc: self, actionHandler: nil)
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
           shareSum == amount
        {
            // 找到對應的字典
            let transactionType = TransactionType(iconName: "", name: TransactionMainType.expenses.text)
            // swiftlint:disable line_length
            let transaction = Transaction(transactionType: transactionType,
                                          amount: -amount,
                                          currency: "新台幣",
                                          date: selectDate,
                                          note: note,
                                          payUser: memberPayMoney,
                                          shareUser: memberShareMoney,
                                          subType: subType)
            LKProgressHUD.show()
            firebase.postData(toAccountID: currentAccountID, transaction: transaction, memberPayMoney: memberPayMoney, memberShareMoney: memberShareMoney) { result in
                switch result {
                case let .success(success):
                    LKProgressHUD.showSuccess()
                case let .failure(failure):
                    LKProgressHUD.showFailure()
                }
            }

            var payUsersID: [String] = []
            for userID in memberPayMoney.keys {
                payUsersID.append(userID)
            }

            if let accountName = saveData.accountData?.accountName,
               saveData.accountData?.accountID != saveData.myInfo?.ownAccount
            {
                let usersInfo = saveData.userInfoData
                firebase.postUpdatePayerAccount(isMyAccount: false,
                                                formAccountName: accountName,
                                                usersInfo: usersInfo,
                                                transaction: transaction)
                { result in
                    switch result {
                    case let .success(success):
                        LKProgressHUD.showSuccess(text: "同步到支出者帳本")
                    case let .failure(failure):
                        LKProgressHUD.showSuccess(text: "無法同步到支出者帳本")
                    }
                }
            }
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
        if saveData.userInfoData != nil {
//            var usersKey: [String] = []

            for user in saveData.userInfoData {
                memberPayMoney[user.userID] = 0
                memberShareMoney[user.userID] = 0
            }
        }
    }

    // MARK: - 拍攝發票

    func selectPhotoButtonTapped() {
//        LKProgressHUD.show(inView: self.view)
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "從相簿中選擇", style: .default) { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        })

        alertController.addAction(UIAlertAction(title: "拍照", style: .default) { _ in
            self.showImagePicker(sourceType: .camera)
        })

        alertController.addAction(UIAlertAction(title: "取消", style: .cancel) { _ in
//            LKProgressHUD.dismiss()
        })

        present(alertController, animated: true)
    }

    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
//        LKProgressHUD.show(inView: self.view)
        if sourceType == .photoLibrary {
            imagePicker.sourceType = sourceType
            present(imagePicker, animated: true, completion: nil)
        } else if sourceType == .camera {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = sourceType
                present(imagePicker, animated: true, completion: nil)
//                LKProgressHUD.dismiss()
            } else {
                LKProgressHUD.showFailure(inView: view, text: "設備不支援相機")
                print("設備不支援相機")
            }
        } else {
            LKProgressHUD.showFailure(inView: view, text: "相機不可用或其他情况")
            print("相機不可用或其他情况")
        }
    }
}

extension AddNewItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell

        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "moneyCell", for: indexPath)
            cell.selectionStyle = .none
            guard let moneyCell = cell as? ANIMoneyTableViewCell else { return cell }
            moneyCell.iconImageView.image = UIImage(named: AllIcons.moneyAndCoin.rawValue)
//
            let amountString = String(format: "%.2f", amount ?? 0.0)
            moneyCell.inputTextField.text = amountString
//                amount = Double(invoiceTotalAmount)

            moneyCell.inputTextField.addTarget(self, action: #selector(getAmount(_:)), for: .editingChanged)
            return moneyCell

        } else if indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath)
            cell.selectionStyle = .none
            guard let typeCell = cell as? ANITypeTableViewCell else { return cell }

            return typeCell

        } else if indexPath.row == 2 {
            // 掃描發票
            cell = tableView.dequeueReusableCell(withIdentifier: "invoiceCell", for: indexPath)
            cell.selectionStyle = .none
            guard let invoiceCell = cell as? ANIInvoiceTableViewCell else { return cell }
            invoiceCell.invoiceLabel.text = ""
//            invoiceCell.invoiceLabel.text = "\(invoiceString.count)\n"

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

        } else if indexPath.row == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            cell.selectionStyle = .none
            guard let dateCell = cell as? ANISelectDateTableViewCell else { return cell }
//            selectDate = dateCell.datePicker.date
//            dateCell.datePicker.date = selectDatex
            dateCell.datePicker.addTarget(self, action: #selector(datePickerDidChange(_:)), for: .valueChanged)

            return dateCell

        } else if indexPath.row == 4 {
            cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
            cell.selectionStyle = .none
            guard let memberPayCell = cell as? ANIMemberTableViewCell else { return cell }
            memberPayCell.showTitleLabel.text = "付款"
            memberPayCell.usersMoney = memberPayMoney

            return memberPayCell

        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
            cell.selectionStyle = .none
            guard let memberShareCell = cell as? ANIMemberTableViewCell else { return cell }
            memberShareCell.showTitleLabel.text = "分款"
            memberShareCell.usersMoney = memberShareMoney

            return memberShareCell
        }
    }

    @objc func getAmount(_ textField: UITextField) {
        amount = Double(textField.text ?? "0.0")
        checkButtonColorChange()
    }

    // DatePicker 的值變化時的動作
    @objc func datePickerDidChange(_ datePicker: UIDatePicker) {
        selectDate = datePicker.date
        print(selectDate)
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let subTypeVC = SelectSubTypeViewController()
            subTypeVC.modalPresentationStyle = .automatic
            subTypeVC.modalTransitionStyle = .coverVertical
            subTypeVC.sheetPresentationController?.detents = [.custom(resolver: { context in
                context.maximumDetentValue * 0.5
            }
            )]

            subTypeVC.selectedSubType = { iconName, title in
                self.type = TransactionType(iconName: iconName, name: title)
                if let index = subTypeVC.selectedIndex {
                    let cell = self.table.cellForRow(at: IndexPath(row: 1, section: 0)) as? ANITypeTableViewCell
                    cell?.iconImageView.image = UIImage(named: iconName)
                    cell?.titleLabel.text = title
                }
                print(subTypeVC.selectedIndex)
                print(self.type)
                self.checkButtonColorChange()
            }

            present(subTypeVC, animated: true, completion: nil)
        } else if indexPath.row == 2 {
//            LKProgressHUD.show(inView: self.view)
            selectPhotoButtonTapped()
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
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
//            LKProgressHUD.dismiss()
            LKProgressHUD.show(inView: view)
            scanInvoiceManager.displayBarcodeResults(view: self, selectedImage: selectedImage) { results in
                switch results {
                case let .success(result):
                    switch result {
                    case .formQRCode:
                        self.invoiceNumber = self.scanInvoiceManager.invoiceNumber
                        self.invoiceDate = self.scanInvoiceManager.invoiceDateString
                        self.selectDate = self.scanInvoiceManager.invoiceDate
                        self.invoiceRandomNumber = self.scanInvoiceManager.invoiceRandomNumber
                        self.invoiceTotalAmount = self.scanInvoiceManager.invoiceTotalAmount
                        self.productDetails = self.scanInvoiceManager.productDetails
                        LKProgressHUD.showSuccess(inView: self.view)

                    case .formText:
                        self.invoiceNumber = self.scanInvoiceManager.invoiceNumber
                        LKProgressHUD.showSuccess(inView: self.view)
                    }
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
