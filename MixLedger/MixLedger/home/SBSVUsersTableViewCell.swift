//
//  SBSVUsersTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/16.
//

import UIKit
import SnapKit
class SBSVUsersTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupLayout()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        setupLayout()
    }
    
    let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image  = UIImage(named: "human")
        return imageView
    }()
    
    let nameLable: UILabel = {
        let lable = UILabel()
        lable.text = "puma"
        return lable
    }()
    
    let moneyLable: UILabel = {
        let lable = UILabel()
        lable.text = "300"
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
    
    func setupLayout(){
        addSubview(userImage)
        addSubview(nameLable)
        addSubview(moneyLable)
        addSubview(checkButton)
        userImage.snp.makeConstraints{(mark) in
            mark.height.width.equalTo(20)
            mark.top.leading.equalTo(contentView).offset(12)
            mark.bottom.equalTo(contentView).offset(-12)
        }
        
        nameLable.snp.makeConstraints{(mark) in
            mark.centerY.equalTo(contentView)
            mark.leading.equalTo(userImage.snp.trailing).offset(12)
        }
        
        moneyLable.snp.makeConstraints{(mark) in
            mark.centerX.equalTo(self)
            mark.centerY.equalTo(self)
        }
        
        checkButton.snp.makeConstraints{(mark) in
            mark.centerY.centerY.equalTo(contentView)
            mark.trailing.equalTo(contentView.snp.trailing).offset(-12)
            mark.width.equalTo(60)
//            mark.height.equalTo(12)
        }
    }
    
    
}
