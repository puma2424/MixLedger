//
//  ANIInvoiceTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/25.
//

import UIKit

class ANIInvoiceTableViewCell: AddNewItemModelTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupCell()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell() {
        titleLabel.text = "掃描發票"
        iconImageView.image = AllIcons.receipt.icon
        setupHiden(titleLabelHidden: false)
    }

    let invoiceLabel: UILabel = {
        let label = UILabel()
        label.text = "aaaaaaaaaaaaaaaaa"
        label.numberOfLines = 0
        return label
    }()

    func resetLayout() {
        iconImageView.snp.removeConstraints()
        titleLabel.snp.removeConstraints()
        contentView.addSubview(invoiceLabel)

        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.equalTo(contentView).offset(12)
            make.leading.equalTo(contentView).offset(12)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(24)
        }

        invoiceLabel.snp.makeConstraints { mark in
            mark.leading.equalTo(titleLabel)
            mark.trailing.equalTo(contentView).offset(-12)
            mark.top.equalTo(titleLabel.snp.bottom).offset(12)
            mark.bottom.equalTo(contentView.snp.bottom).offset(-12)
        }
    }
}
