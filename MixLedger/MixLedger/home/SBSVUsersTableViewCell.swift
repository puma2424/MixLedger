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

    let checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("催款", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        return button
    }()
    
    let messageButton: UIButton = {
        let button = UIButton()
        button.setTitle("催款", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        return button
    }()

    @objc func checkButtonTarget(){
        delegate?.checkButtonTarget(cell: self)
    }
    
    func setupButton(){
        checkButton.addTarget(self, action: #selector(checkButtonTarget), for: .touchUpInside)
    }
    
    func setupLayout() {
        contentView.addSubview(userImage)
        contentView.addSubview(nameLable)
        contentView.addSubview(moneyLable)
//        contentView.addSubview(messageButton)
        contentView.addSubview(checkButton)
        
        userImage.snp.makeConstraints { mark in
            mark.height.width.equalTo(20)
            mark.top.leading.equalTo(contentView).offset(12)
            
        }

        nameLable.snp.makeConstraints { mark in
            mark.centerY.equalTo(userImage)
            mark.leading.equalTo(userImage.snp.trailing).offset(12)
        }

        moneyLable.snp.makeConstraints { mark in
            mark.centerX.equalTo(contentView)
            mark.centerY.equalTo(userImage)
        }
        
//        messageButton.snp.makeConstraints{(mark) in
//            mark.top.equalTo(moneyLable.snp.bottom).offset(12)
//            mark.leading.equalTo(contentView).offset(12)
//            mark.width.equalTo(contentView.frame.size.width / 2 - 18)
//        }
    
        checkButton.snp.makeConstraints { mark in
//            mark.centerY.equalTo(contentView)
            mark.top.equalTo(moneyLable.snp.bottom).offset(12)
            mark.trailing.equalTo(contentView.snp.trailing).offset(-12)
            mark.width.equalTo((contentView.bounds.size.width - 36) / 2)
            mark.bottom.equalTo(contentView).offset(-12)
        }
    }
}
