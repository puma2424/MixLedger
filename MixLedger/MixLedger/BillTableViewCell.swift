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
        setupView()
    }
    let sortImageView = UIImageView()
    let titleLabel = UILabel()
    let titleNoteLabel = UILabel()
    let moneyLabel = UILabel()
    let moneyNoteLabel = UILabel()
    let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.alignment = .fill // 確保子視圖填滿水平空間
        stackView.spacing = 5 // 設置子視圖之間的間距
        return stackView
    }()
    let moneyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing // 將 alignment 設定為 .center
        stackView.distribution = .fillEqually
        stackView.alignment = .fill // 確保子視圖填滿水平空間
        stackView.spacing = 5 // 設置子視圖之間的間距
        return stackView
    }()
    func setupView(){
//        sortImageView.image = UIImage(named: "more")
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleNoteLabel.font = UIFont.systemFont(ofSize: 13)
        moneyLabel.font = UIFont.systemFont(ofSize: 15)
        moneyNoteLabel.font = UIFont.systemFont(ofSize: 13)
        
        moneyLabel.textAlignment = .right
        moneyNoteLabel.textAlignment = .right
        
        moneyLabel.numberOfLines = 1
        moneyNoteLabel.numberOfLines = 1
        titleNoteLabel.numberOfLines = 1
        titleLabel.numberOfLines = 1
        contentView.addSubview(sortImageView)
        contentView.addSubview(titleStackView)
        contentView.addSubview(moneyStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleNoteLabel)
        moneyStackView.addArrangedSubview(moneyLabel)
        moneyStackView.addArrangedSubview(moneyNoteLabel)
        
        sortImageView.snp.makeConstraints{(mark) in
            mark.width.height.equalTo(50)
            mark.leading.equalTo(contentView).offset(2)
            mark.centerY.equalTo(contentView)
            
        }
        
        titleStackView.snp.makeConstraints { (mark) in
            mark.top.equalTo(sortImageView).offset(5)
               mark.leading.equalTo(sortImageView.snp.trailing).offset(2)
               mark.trailing.lessThanOrEqualTo(moneyStackView.snp.leading).offset(-8) // 設置 titleStackView 右邊不超過 moneyStackView 的左邊
            mark.bottom.equalTo(contentView).offset(-5)
           }
        
        moneyStackView.snp.makeConstraints { (mark) in
            mark.width.equalTo(80)
            mark.top.equalTo(sortImageView).offset(5)
            mark.trailing.equalTo(contentView.snp.trailing).offset(-5)
        }
        
        
    }
    
}


