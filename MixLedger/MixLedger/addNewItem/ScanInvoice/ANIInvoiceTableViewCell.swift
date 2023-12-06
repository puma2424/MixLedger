//
//  ANIInvoiceTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/25.
//

import UIKit

class ANIInvoiceTableViewCell: UITableViewCell {
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

    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "掃描發票"
        return label
    }()

    let invoiceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        return label
    }()

    func setupLayout() {
//        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(invoiceLabel)

//        iconImageView.snp.makeConstraints { mark in
//            mark.width.height.equalTo(50)
//            mark.top.equalTo(contentView).offset(12)
////            mark.bottom.equalTo(contentView).offset(-12)
//            mark.leading.equalTo(contentView).offset(12)
//        }

        titleLabel.snp.makeConstraints { mark in
            mark.top.equalTo(contentView).offset(12)
            mark.leading.equalTo(contentView.snp.leading).offset(12)
        }

        invoiceLabel.snp.makeConstraints { mark in
            mark.leading.equalTo(contentView).offset(12)
            mark.trailing.equalTo(contentView).offset(-12)
            mark.top.equalTo(titleLabel.snp.bottom).offset(12)
            mark.bottom.equalTo(contentView.snp.bottom).offset(-12)
        }
    }
}
