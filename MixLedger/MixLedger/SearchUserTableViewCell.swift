//
//  SearchUserTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/22.
//

import UIKit

class SearchUserTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
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
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "G1")
        return label
    }()
    
    var postButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "G3")
        button.setTitleColor(UIColor(named: "G1"), for: .normal)
        button.setTitle("post", for: .normal)
        return button
    }()
    
    func setupLayout(){
        contentView.addSubview(nameLabel)
        contentView.addSubview(postButton)
        
        nameLabel.snp.makeConstraints{(mark) in
            mark.leading.equalTo(contentView).offset(16)
//            mark.centerY.equalTo(contentView)
            mark.top.equalTo(contentView).offset(16)
            mark.bottom.equalTo(contentView).offset(-16)
        }
        
        postButton.snp.makeConstraints{(mark) in
            mark.trailing.equalTo(contentView).offset(-16)
            mark.centerY.equalTo(contentView)
            mark.width.equalTo(80)
            
        }
    }

}
