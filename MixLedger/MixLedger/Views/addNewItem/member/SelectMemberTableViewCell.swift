//
//  SelectMemberTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/23.
//

import SnapKit
import UIKit

class SelectMemberTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupLayout()
        setupTextField()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var changeMoney: ((String) -> Void)?

    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "hihihihihihihihihihi"
        return label
    }()

    let moneyTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .decimalPad
        // 尚未輸入時的預設顯示提示文字
        textField.placeholder = "請輸入金額"
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

    @objc func inputMoney(_ textField: UITextField) {
        if let text = textField.text {
            print(textField.text)
            changeMoney?(text)
        } else {
            changeMoney?("0.0")
        }
    }

    func setupTextField() {
        moneyTextField.delegate = self
        moneyTextField.addTarget(self, action: #selector(inputMoney(_:)), for: .editingChanged)
    }

    func setupLayout() {
        contentView.addSubview(moneyTextField)
        contentView.addSubview(nameLabel)

        nameLabel.snp.makeConstraints { mark in
            mark.top.equalTo(contentView).offset(12)
            mark.bottom.equalTo(contentView).offset(-12)
            mark.leading.equalTo(contentView).offset(12)
            mark.trailing.equalTo(moneyTextField.snp.leading).offset(-12)
        }

        moneyTextField.snp.makeConstraints { mark in
            mark.centerY.equalTo(contentView)
            mark.trailing.equalTo(contentView).offset(-12)
            mark.width.equalTo(100)
            mark.height.equalTo(35)
        }
    }
}

extension SelectMemberTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 隱藏鍵盤
        textField.resignFirstResponder()
        return true
    }
}
