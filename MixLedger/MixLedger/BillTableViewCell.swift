//
//  BillTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/16.
//

import UIKit
import SnapKit
class BillTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    let sortImageView = UIImageView()
    let titleLabel = UILabel()
    let ownerLabel = UILabel()
    let moneyLabel = UILabel()
    let notLabel = UILabel()
    
    func setupView(){
        titleLabel.font = UIFont(name: "",size: 15)
        ownerLabel.font = UIFont(name: "", size: 13)
        moneyLabel.font = UIFont(name: "", size: 15)
        notLabel.font = UIFont(name: "", size: 13)
        contentView.addSubview(sortImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ownerLabel)
        contentView.addSubview(moneyLabel)
        contentView.addSubview(notLabel)
        
        sortImageView.snp.makeConstraints{(mark) in
            mark.width.height.equalTo(48)
            mark.top.leading.bottom.equalTo(contentView).offset(-2)
            
        }
        
    }
    
}


