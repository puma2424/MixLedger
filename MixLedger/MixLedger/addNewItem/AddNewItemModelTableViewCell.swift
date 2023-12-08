//
//  AddNewItemModelTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import SnapKit
import UIKit
class AddNewItemModelTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupLayout()
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

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .g1()
        label.text = "qqq"
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    let inputTextField: UITextField = {
        let textField = UITextField()

        // 輸入框右邊顯示清除按鈕時機 這邊選擇當編輯時顯示
        textField.clearButtonMode = .whileEditing

        // 輸入框適用的鍵盤 這邊選擇 適用輸入 Email 的鍵盤(會有 @ 跟 . 可供輸入)
        textField.keyboardType = .decimalPad

        // 鍵盤上的 return 鍵樣式 這邊選擇 Done
        textField.returnKeyType = .done

        // 輸入文字的顏色
        textField.textColor = .g1()
        return textField
    }()

    func setupHiden(titleLabelHiden: Bool, inputTextFieldHiden: Bool){
        titleLabel.isHidden = titleLabelHiden
        inputTextField.isHidden = inputTextFieldHiden
    }
    
    func setupLayout() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(inputTextField)
        contentView.addSubview(titleLabel)
        
        iconImageView.snp.makeConstraints { mark in
            mark.width.height.equalTo(50)
            mark.top.equalTo(contentView).offset(12)
            mark.bottom.equalTo(contentView).offset(-12)
            mark.leading.equalTo(contentView).offset(12)
        }

        inputTextField.snp.makeConstraints { mark in
            mark.width.equalTo(150)
            mark.height.equalTo(45)
            mark.centerY.equalTo(contentView)
            mark.trailing.equalTo(contentView.snp.trailing).offset(-12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(24)
        }
    }
}
