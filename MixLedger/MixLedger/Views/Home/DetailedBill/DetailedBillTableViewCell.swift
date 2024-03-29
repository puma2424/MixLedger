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
        backgroundColor = .clear
    }

    // 如果是使用 Interface Builder，這個初始化方法會被呼叫
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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

    let moneyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    let payOrShareLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    func setupForUserLayout() {
        contentLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        moneyLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        iconImageView.snp.removeConstraints()
        contentLabel.snp.removeConstraints()
        addSubview(moneyLabel)
        addSubview(payOrShareLabel)

        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(12)
            make.width.height.equalTo(40)
            make.centerY.equalTo(self)
        }

        contentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(moneyLabel.snp.leading).offset(-12)
        }

        moneyLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.centerY)
            make.trailing.equalTo(contentView).offset(-24)
        }

        payOrShareLabel.snp.makeConstraints { make in
            make.top.equalTo(moneyLabel.snp.bottom)
            make.trailing.equalTo(moneyLabel)
        }
    }

    func setupLayout() {
        addSubview(iconImageView)
        addSubview(contentLabel)

        contentLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(iconImageView)
            make.top.equalTo(self).offset(18)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.bottom.equalTo(self).offset(-15)
        }

        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(10)
            make.leading.equalTo(self).offset(12)
            make.width.height.equalTo(40)
        }
    }
}
