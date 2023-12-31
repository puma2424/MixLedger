//
//  ANIMoneyTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import SnapKit
import UIKit
class ANIMoneyTableViewCell: /* UITableViewCell */ AddNewItemModelTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupHiden(inputTextFieldHidden: false)
        inputTextField.placeholder = "請輸入金額"
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

//    let iconImageView: UIImageView = {
//        let imageView = UIImageView()
//        return imageView
//    }()
//
//
//
//    let inputTextField: UITextField = {
//        let textField = UITextField()
//        // 尚未輸入時的預設顯示提示文字
//        textField.placeholder = "請輸入金額"
//
//        // 輸入框右邊顯示清除按鈕時機 這邊選擇當編輯時顯示
//        textField.clearButtonMode = .whileEditing
//
//        // 輸入框適用的鍵盤 這邊選擇 適用輸入 Email 的鍵盤(會有 @ 跟 . 可供輸入)
//        textField.keyboardType = .numberPad
//
//        // 鍵盤上的 return 鍵樣式 這邊選擇 Done
//        textField.returnKeyType = .done
//
//        // 輸入文字的顏色
//        textField.textColor = UIColor(named: "G1")
//        return textField
//    }()
//
//
//
//    func setupLayout() {
//        contentView.addSubview(iconImageView)
//        contentView.addSubview(inputTextField)
//
//        iconImageView.snp.makeConstraints { mark in
//            mark.width.height.equalTo(50)
//            mark.top.equalTo(contentView).offset(12)
//            mark.bottom.equalTo(contentView).offset(-12)
//            mark.leading.equalTo(contentView).offset(12)
//        }
//
//        inputTextField.snp.makeConstraints { mark in
//            mark.width.equalTo(150)
//            mark.height.equalTo(45)
//            mark.centerY.equalTo(contentView)
//            mark.trailing.equalTo(contentView.snp.trailing).offset(-12)
//        }
//
//    }
}
