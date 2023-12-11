//
//  AddNewAccountViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/21.
//

import SnapKit
import UIKit

class AddNewAccountViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setView()
        setupTextField()
        view.backgroundColor = UIColor(named: "G3")
        setupCollectionView()
        setCheckButton()
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

    let iconView = UIView()
    var selectedIndexPath: IndexPath?
    var accountName: String?
    var selectedIcon: String?
    var accountBudget: String?

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "名  稱"
        label.textColor = UIColor(named: "G1")
        return label
    }()

    let budgetLabel: UILabel = {
        let label = UILabel()
        label.text = "預  算"
        label.textColor = UIColor(named: "G1")
        return label
    }()

    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        // 尚未輸入時的預設顯示提示文字
        textField.placeholder = "請輸入帳簿名稱"

        // 輸入框右邊顯示清除按鈕時機 這邊選擇當編輯時顯示
        textField.clearButtonMode = .whileEditing

        // 鍵盤上的 return 鍵樣式 這邊選擇 Done
        textField.returnKeyType = .done
        textField.textAlignment = .center
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(named: "G2")
        textField.textColor = UIColor(named: "G1")
        return textField
    }()

    let budgetTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        // 尚未輸入時的預設顯示提示文字
        textField.placeholder = "請輸入預算"

        // 輸入框右邊顯示清除按鈕時機 這邊選擇當編輯時顯示
        textField.clearButtonMode = .whileEditing

        // 鍵盤上的 return 鍵樣式 這邊選擇 Done
        textField.returnKeyType = .done
        textField.textAlignment = .center
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(named: "G2")
        textField.textColor = UIColor(named: "G1")
        return textField
    }()

    let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
//        stackView.alignment = .center // 將 alignment 設定為 .center
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill // 確保子視圖填滿水平空間
        stackView.spacing = 5 // 設置子視圖之間的間距
        return stackView
    }()

    let budgetStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
//        stackView.alignment = .center // 將 alignment 設定為 .center
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill // 確保子視圖填滿水平空間
        stackView.spacing = 5 // 設置子視圖之間的間距
        return stackView
    }()

    let checkButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setTitle("確      認", for: .normal)
        button.backgroundColor = UIColor(named: "G1")
        button.layer.cornerRadius = 10
        return button
    }()

    func setCheckButton() {
        checkButton.addTarget(self, action: #selector(checkButtonActive), for: .touchUpInside)
    }

    func setupTextField() {
        nameTextField.delegate = self
        budgetTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(inputName(_:)), for: .editingChanged)
        budgetTextField.addTarget(self, action: #selector(inputbudget(_:)), for: .editingChanged)
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        // 設置每一行的間距
        layout.minimumLineSpacing = 20
        // 設置 item 之間的最小間距
        // layout.minimumInteritemSpacing = 30
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .vertical // 或者 .horizontal，取決於你的需求
        let iconCollectioView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        iconCollectioView.layer.cornerRadius = 10
        iconCollectioView.backgroundColor = .clear

        iconCollectioView.delegate = self
        iconCollectioView.dataSource = self

        iconView.backgroundColor = .clear
        view.addSubview(iconView)
        iconView.addSubview(iconCollectioView)

        iconView.snp.makeConstraints { mark in
            mark.top.equalTo(budgetStackView.snp.bottom).offset(50)
            mark.leading.equalTo(budgetStackView)
            mark.trailing.equalTo(budgetStackView)
            mark.bottom.equalTo(view.snp.bottom).offset(-100)
        }
        iconCollectioView.snp.makeConstraints { mark in
            mark.top.leading.equalTo(iconView)
            mark.trailing.equalTo(iconView)
            mark.top.equalTo(iconView.snp.bottom)
            mark.bottom.equalTo(iconView)
        }

        iconCollectioView.register(
            ANAIconCollectionViewCell.self,
            forCellWithReuseIdentifier: "Cell"
        )
    }

    func setView() {
        view.addSubview(budgetStackView)
        budgetStackView.addArrangedSubview(budgetLabel)
        budgetStackView.addArrangedSubview(budgetTextField)

        view.addSubview(checkButton)

        view.addSubview(nameStackView)
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(nameTextField)

        nameStackView.snp.makeConstraints { mark in
            mark.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            mark.centerX.equalTo(view.snp.centerX)
            mark.height.equalTo(50)
            mark.width.equalTo(view.frame.size.width * 0.9)
        }

        nameTextField.snp.makeConstraints { mark in
            mark.leading.equalTo(nameLabel.snp.trailing).offset(20)
        }

        budgetStackView.snp.makeConstraints { mark in
            mark.top.equalTo(nameStackView.snp.bottom).offset(50)
            mark.centerX.equalTo(view.snp.centerX)
            mark.height.equalTo(50)
            mark.width.equalTo(view.frame.size.width * 0.9)
        }

        budgetTextField.snp.makeConstraints { mark in
            mark.leading.equalTo(budgetLabel.snp.trailing).offset(20)
        }

        checkButton.snp.makeConstraints { mark in
            mark.width.equalTo(view.bounds.size.width * 0.8)
            mark.height.equalTo(50)
            mark.centerX.equalTo(view)
            mark.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
    }

    @objc func inputName(_ textField: UITextField) {
        accountName = textField.text
        if let text = accountName, !text.isEmpty, selectedIcon != nil {
            checkButton.isHidden = false

        } else {
            checkButton.isHidden = true
        }
//        textField.resignFirstResponder()
    }

    @objc func inputbudget(_ textField: UITextField) {
        accountBudget = textField.text
        print(textField.text)
    }

    @objc func checkButtonActive() {
        guard let name = accountName else { return }
//        guard let budget = accountBudget as? Double else {return}
        guard let icon = selectedIcon else { return }
        if accountBudget != nil, let budget = accountBudget as? Double {
            firebaseManager.addNewAccount(name: name, budget: budget, iconName: icon){ result in
                switch result {
                case .success(let success):
                    self.dismiss(animated: true)
                    LKProgressHUD.showSuccess()
                case .failure(let failure):
                    self.dismiss(animated: true)
                    LKProgressHUD.showFailure()
                }
            }
        } else {
            firebaseManager.addNewAccount(name: name, iconName: icon){ result in
                switch result {
                case .success(let success):
                    self.dismiss(animated: true)
                    LKProgressHUD.showSuccess()
                case .failure(let failure):
                    self.dismiss(animated: true)
                    LKProgressHUD.showFailure()
                }
            }
        }
    }
}

extension AddNewAccountViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return AllIcons.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        guard let iconCell = cell as? ANAIconCollectionViewCell else { return cell }
        iconCell.imageView.image = AllIcons.allCases[indexPath.row].icon
        return iconCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 在這裡處理點擊事件
        print("Cell at index \(indexPath.item) selected")
        guard let cell = collectionView.cellForItem(at: indexPath) as? ANAIconCollectionViewCell else { return }
        // 取消先前選中的 cell 的勾勾
        if let selectedIndexPath = selectedIndexPath {
            guard let previousSelectedCell = collectionView.cellForItem(at: selectedIndexPath) as? ANAIconCollectionViewCell else { return }
            previousSelectedCell.colorView.backgroundColor = .clear
            previousSelectedCell.colorView.layer.borderWidth = 0
        }

        // 更新當前選中的 indexPath
        selectedIndexPath = indexPath
        cell.colorView.backgroundColor = UIColor(named: "G2")
        cell.colorView.layer.borderWidth = 1
        cell.colorView.layer.cornerRadius = 10

        selectedIcon = AllIcons.allCases[indexPath.row].rawValue

        if accountName != nil, selectedIcon != nil {
            checkButton.isHidden = false
        }
    }
}

extension AddNewAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 隱藏鍵盤
        textField.resignFirstResponder()
        return true
    }
}
