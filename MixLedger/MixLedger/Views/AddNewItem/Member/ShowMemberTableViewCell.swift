//
//  ShowMemberTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/23.
//

import SnapKit
import UIKit

class ShowMemberTableViewCell: UITableViewCell {
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

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .g1()
        return label
    }()

    let moneyLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .g1()
        return label
    }()

    func setupLayout() {
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(moneyLabel)
        addSubview(nameLabel)

        moneyLabel.snp.makeConstraints { mark in
            mark.top.equalTo(self).offset(12)
            mark.bottom.equalTo(self).offset(-12)
            mark.trailing.equalTo(self.snp.trailing).offset(-20)
        }

        nameLabel.snp.makeConstraints { mark in
            mark.centerY.equalTo(self)
            mark.leading.equalTo(self).offset(20)
            mark.trailing.lessThanOrEqualTo(moneyLabel.snp.leading).offset(-12)
        }
    }
}
