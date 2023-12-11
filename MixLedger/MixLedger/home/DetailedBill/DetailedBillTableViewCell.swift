//
//  DetailedBillTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/11.
//

import UIKit

class DetailedBillTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        self.backgroundColor = .clear
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
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    func setupLayout(){
        addSubview(iconImageView)
        addSubview(contentLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(12)
            make.leading.equalTo(self).offset(12)
            make.width.height.equalTo(40)
            make.bottom.equalTo(self).offset(-12)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.bottom.equalTo(self).offset(-12)
        }
    }

}
