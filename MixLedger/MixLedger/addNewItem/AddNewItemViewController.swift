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

    var memberPayMoney: [String: Double] = [:]

    var memberShareMoney: [String: Double] = [:]

    var amount: Double?

    var member: String?

    var selectDate: Date?

    var type: TransactionType?

    let table = UITableView()
    
    let imagePicker = UIImagePickerController()
    
    var invoiceString: [String] = []
    
    var invoiceNumber: String = ""
    
    var invoiceDate: String = ""
    
    var invoiceRandomNumber: String = ""
    
    var invoiceTotalAmount: String = ""
    
    var invoiceOfChineseEncodingParameter: ChineseEncodingParameter?
    
    var productDetails: [ProductInfo] = []

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
        button.backgroundColor = UIColor(named: "G1")
        button.layer.cornerRadius = 10
        return button
    }()

    @objc func checkButtonActive() {
        if amount == nil {
        } else {
            // 找到對應的字典

            // swiftlint:disable line_length
            firebase.postData(toAccountID: currentAccountID, amount: -(amount ?? 0), date: selectDate ?? Date(), note: "草莓", type: type, memberPayMoney: memberPayMoney, memberShareMoney: memberShareMoney) { _ in
                self.dismiss(animated: true)
            }
            // swiftlint:enable line_length
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
            var usersKey: [String] = []

            for key in saveData.userInfoData.keys {
                memberPayMoney[key] = 0
                memberShareMoney[key] = 0
            }
        }
    }
    
    // MARK: - 拍攝發票
    func selectPhotoButtonTapped() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "從相簿中選擇", style: .default) { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        })

        alertController.addAction(UIAlertAction(title: "拍照", style: .default) { _ in
            self.showImagePicker(sourceType: .camera)
        })

        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))

        present(alertController, animated: true)
    }
        
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        if sourceType == .photoLibrary {
            imagePicker.sourceType = sourceType
            present(imagePicker, animated: true, completion: nil)
        } else if sourceType == .camera {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = sourceType
                present(imagePicker, animated: true, completion: nil)
            } else {
                print("設備不支援相機")
            }
        } else {
            print("相機不可用或其他情况")
        }
    }
    
}

extension AddNewItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "moneyCell", for: indexPath)
            guard let moneyCell = cell as? ANIMoneyTableViewCell else { return cell }
            moneyCell.iconImageView.image = UIImage(named: AllIcons.moneyAndCoin.rawValue)
            if invoiceTotalAmount != ""{
                moneyCell.inputText.text = invoiceTotalAmount
                
            }else{
                moneyCell.inputText.text = ""
            }
            moneyCell.inputText.addTarget(self, action: #selector(getAmount(_:)), for: .editingChanged)
            
            

        } else if indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath)
            guard let typeCell = cell as? ANITypeTableViewCell else { return cell }
            typeCell.iconImageView.image = UIImage(named: AllIcons.foodRice.rawValue)

            typeCell.inputText.addTarget(self, action: #selector(getType(_:)), for: .editingChanged)
//            if let text =  typeCell.inputText.text{
//                type?.name = text
//            }

        }else if indexPath.row == 2 {
            // 掃描發票
            cell = tableView.dequeueReusableCell(withIdentifier: "invoiceCell", for: indexPath)
            guard let invoiceCell = cell as? ANIInvoiceTableViewCell else { return cell }
            invoiceCell.iconImageView.image = UIImage(named: AllIcons.foodRice.rawValue)
            invoiceCell.invoiceLabel.text = ""
            invoiceCell.invoiceLabel.text = "\(invoiceString.count)\n"
//            for index in 0..<invoiceString.count{
//                invoiceCell.invoiceLabel.text? += "\(index)：\n\(invoiceString[index])\n"
//            }
            var text = ""
            if invoiceNumber != ""{
                text = "發票號碼： \(invoiceNumber)"
            }
            
            if invoiceDate != ""{
                text += "\n購買日期：\(invoiceDate)"
            }
            
            if invoiceRandomNumber != ""{
                text += "\n隨機碼：\(invoiceRandomNumber)"
            }
            
            if invoiceTotalAmount != "" {
                text += "\n金額：\(invoiceTotalAmount)"
            }
            print(productDetails)
            for product in productDetails{
                text += "\n 商品： \(product.name) \(product.price) * \(product.quantity)"
            }
            invoiceCell.invoiceLabel.text = text
            

        }else if indexPath.row == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            guard let dateCell = cell as? ANISelectDateTableViewCell else { return cell }
            dateCell.iconImageView.image = UIImage(named: AllIcons.person.rawValue)
//            selectDate = dateCell.datePicker.date
            dateCell.datePicker.date = selectDate ?? Date()
            dateCell.datePicker.addTarget(self, action: #selector(datePickerDidChange(_:)), for: .valueChanged)

        } else if indexPath.row == 4 {
            cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)

            guard let memberPayCell = cell as? ANIMemberTableViewCell else { return cell }
            memberPayCell.showTitleLabel.text = "付款"
            memberPayCell.usersMoney = memberPayMoney

        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)

            guard let memberShareCell = cell as? ANIMemberTableViewCell else { return cell }
            memberShareCell.showTitleLabel.text = "分款"
            memberShareCell.usersMoney = memberShareMoney
        }
        return cell
    }

    @objc func getType(_ textField: UITextField) {
        if let text = textField.text {
            type = TransactionType(iconName: AllIcons.edit.rawValue, name: text)
        }
    }

    @objc func getAmount(_ textField: UITextField) {
        amount = Double(textField.text ?? "")
    }

    // DatePicker 的值變化時的動作
    @objc func datePickerDidChange(_ datePicker: UIDatePicker) {
        // 更新數據結構中相應 cell 的數據
        selectDate = datePicker.date
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{
            selectPhotoButtonTapped()
        }else if indexPath.row == 4 {
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
    }

    func inputShareMemberMoney(cell: SelectMemberViewController) {
        memberShareMoney = cell.usersMoney ?? memberPayMoney
        print(memberShareMoney)
        table.reloadData()
    }
}

extension AddNewItemViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            scanInvoiceManager.displayBarcodeResults(view: self, selectedImage: selectedImage){results in
                switch results{
                    
                case .success(let result):
                    switch result{
                    case .formQRCode(_):
                        self.invoiceNumber = self.scanInvoiceManager.invoiceNumber
                        self.invoiceDate = self.scanInvoiceManager.invoiceDateString
                        self.selectDate = self.scanInvoiceManager.invoiceDate
                        self.invoiceRandomNumber = self.scanInvoiceManager.invoiceRandomNumber
                        self.invoiceTotalAmount = self.scanInvoiceManager.invoiceTotalAmount
                    case .formText(_):
                        self.invoiceNumber = self.scanInvoiceManager.invoiceNumber
                    }
                    self.table.reloadData()
                case .failure(_):
                    return
                }
            }
            
//            self.table.reloadData()
        }
        
        dismiss(animated: true, completion: nil)
        
        
    }
}
