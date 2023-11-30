//
//  RepayView.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/30.
//

import UIKit
import SnapKit

protocol RepayViewDelegate{
    func postRepay(payView: UIView,otherUserName: String, otherUserID: String, amount: Double)
}

class RepayView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        self.backgroundColor = UIColor(named: "G1")
        setTarget()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var delegate: RepayViewDelegate?

    var amount: Double = 0
    
    var otherUserName: String = ""
    
    var otherUserID: String = ""
    
    var otherMoney: Double = 0
    
    let titleLabel: UILabel = {
        let label = UILabel()
//        label.text = "puma待收款金額為：500"
        label.textColor = UIColor(named: "G3")
        return label
    }()
    
    let toUser: UILabel = {
        let label = UILabel()
//        label.text = "向puma還款"
        label.textColor = UIColor(named: "G3")
        return label
    }()
    
    let moneyLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "G3")
        label.text = "元"
        return label
    }()
    
    let payTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        // 尚未輸入時的預設顯示提示文字
        textField.placeholder = "請輸入金額"

        // 輸入框右邊顯示清除按鈕時機 這邊選擇當編輯時顯示
        textField.clearButtonMode = .whileEditing

        // 鍵盤上的 return 鍵樣式 這邊選擇 Done
        textField.returnKeyType = .done
        textField.textAlignment = .center
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(named: "G2")
        textField.textColor = UIColor(named: "G3")
        return textField
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("還款", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "G3")
        button.setTitleColor(UIColor(named: "G1"), for: .normal)
        return button
    }()
    
    func setTarget(){
        checkButton.addTarget(self, action: #selector(checkButtonTarget), for: .touchUpInside)
        payTextField.addTarget(self, action: #selector(payTextFieldTarget(_:)), for: .editingChanged)
    }
    
    @objc func payTextFieldTarget(_ textField: UITextField) {
        if let pay = Double(textField.text ?? "0.0") {
            amount = pay
        }
    }
    
    @objc func checkButtonTarget() {
        delegate?.postRepay(payView: self, otherUserName: otherUserName, otherUserID: otherUserID, amount: amount)
    }
    
    func setLabel(){
        titleLabel.text = "\(otherUserName)待收款金額為：\(otherMoney)"
        toUser.text = "向\(otherUserName)還款"
    }
    func setupLayout(){
        addSubview(titleLabel)
        addSubview(toUser)
        addSubview(payTextField)
//        addSubview(moneyLabel)
        addSubview(checkButton)
        
        titleLabel.snp.makeConstraints{(mark) in
            mark.centerX.equalTo(self)
            mark.top.equalTo(self.snp.top).offset(50)
        }
        
        toUser.snp.makeConstraints{(mark) in
            mark.centerX.equalTo(self)
            mark.top.equalTo(titleLabel.snp.bottom).offset(50)
        }
        
        payTextField.snp.makeConstraints{(mark) in
            mark.width.equalTo(150)
            mark.height.equalTo(50)
            mark.top.equalTo(toUser.snp.bottom).offset(20)
            mark.centerX.equalTo(self)
        }
        
//        moneyLabel.snp.makeConstraints{(mark) in
//            mark.centerY.equalTo(payTextField)
//            mark.leading.equalTo(payTextField.snp.trailing).offset(12)
//        }
        
        checkButton.snp.makeConstraints{(mark) in
            mark.width.equalTo(100)
            mark.height.equalTo(50)
            mark.top.equalTo(payTextField.snp.bottom).offset(50)
            mark.centerX.equalTo(self)
        }
    }
}
