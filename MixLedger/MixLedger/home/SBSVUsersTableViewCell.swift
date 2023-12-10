//
//  SBSVUsersTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/16.
//

import SnapKit
import UIKit

protocol SBSVUsersTableViewCellDelegate{
    func checkButtonTarget(cell: SBSVUsersTableViewCell)
}

class SBSVUsersTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupButton()
        backgroundColor = .g3()
    }

    // 如果是使用 Interface Builder，這個初始化方法會被呼叫
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    var delegate: SBSVUsersTableViewCellDelegate?

    var amount: MoneyType = MoneyType.money(0)
    let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "human")
        return imageView
    }()

    let nameLable: UILabel = {
        let lable = UILabel()
        lable.text = "puma"
        return lable
    }()

    let moneyLable: UILabel = {
        let lable = UILabel()
        lable.text = ""
        return lable
    }()
    
    let statusLable: UILabel = {
        let lable = UILabel()
        lable.text = "pay"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return lable
    }()

    let checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("催款", for: .normal)
        button.setTitleColor(.g3(), for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .brightGreen3()
        return button
    }()
    
    @objc func checkButtonTarget(){
        delegate?.checkButtonTarget(cell: self)
    }
    
    func setupButton(){
        checkButton.addTarget(self, action: #selector(checkButtonTarget), for: .touchUpInside)
    }
    
    func setupNoButtonLayout(){
        
        moneyLable.snp.makeConstraints { mark in
            mark.top.equalTo(contentView).offset(5)
            mark.trailing.equalTo(contentView).offset(-5)
        }
        
        statusLable.snp.makeConstraints { make in
            make.top.equalTo(moneyLable.snp.bottom).offset(5)
            make.trailing.equalTo(moneyLable)
        }
        
        userImage.snp.makeConstraints { mark in
            mark.height.width.equalTo(20)
            mark.leading.equalTo(contentView).offset(12)
            mark.centerY.equalTo(moneyLable.snp.bottom)
        }

        nameLable.snp.makeConstraints { mark in
            mark.centerY.equalTo(userImage)
            mark.leading.equalTo(userImage.snp.trailing).offset(12)
        }
        checkButton.snp.makeConstraints { mark in
            mark.top.equalTo(statusLable.snp.bottom).offset(0)
            mark.leading.equalTo(contentView).offset(12)
            mark.trailing.equalTo(contentView).offset(-12)
            mark.height.equalTo(0)
            mark.bottom.equalTo(contentView).offset(0)
        }
    }
    
    func setupHaveButtonView(){
        
        moneyLable.snp.makeConstraints { mark in
            mark.top.equalTo(contentView).offset(5)
            mark.trailing.equalTo(contentView).offset(-5)
        }
        
        statusLable.snp.makeConstraints { make in
            make.top.equalTo(moneyLable.snp.bottom).offset(5)
            make.trailing.equalTo(moneyLable)
        }
        
        userImage.snp.makeConstraints { mark in
            mark.height.width.equalTo(20)
            mark.leading.equalTo(contentView).offset(12)
            mark.centerY.equalTo(moneyLable.snp.bottom)
        }

        nameLable.snp.makeConstraints { mark in
            mark.centerY.equalTo(userImage)
            mark.leading.equalTo(userImage.snp.trailing).offset(12)
        }

    
        checkButton.snp.makeConstraints { mark in
            mark.top.equalTo(statusLable.snp.bottom).offset(12)
            mark.leading.equalTo(contentView).offset(12)
            mark.trailing.equalTo(contentView).offset(-12)
            mark.height.equalTo(50)
            mark.bottom.equalTo(contentView).offset(-12)
        }
    }
    
    
    func setupLayout() {
        contentView.addSubview(moneyLable)
        contentView.addSubview(statusLable)
        contentView.addSubview(userImage)
        contentView.addSubview(nameLable)
        contentView.addSubview(checkButton)
        
        moneyLable.snp.makeConstraints { mark in
            mark.top.equalTo(contentView).offset(5)
            mark.trailing.equalTo(contentView).offset(-5)
        }
        
        statusLable.snp.makeConstraints { make in
            make.top.equalTo(moneyLable.snp.bottom).offset(5)
            make.trailing.equalTo(moneyLable)
        }
        
        userImage.snp.makeConstraints { mark in
            mark.height.width.equalTo(20)
            mark.leading.equalTo(contentView).offset(12)
            mark.centerY.equalTo(moneyLable.snp.bottom)
        }

        nameLable.snp.makeConstraints { mark in
            mark.centerY.equalTo(userImage)
            mark.leading.equalTo(userImage.snp.trailing).offset(12)
        }

        checkButton.snp.makeConstraints { mark in
            mark.top.equalTo(statusLable.snp.bottom).offset(12)
            mark.leading.equalTo(contentView).offset(12)
            mark.trailing.equalTo(contentView).offset(-12)
            mark.height.equalTo(50)
            mark.bottom.equalTo(contentView).offset(-12)
        }
    }
}
