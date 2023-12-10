//
//  AccountTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import SnapKit
import UIKit
class AccountTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 在 tableView 的父视图中设置阴影
        superview?.layer.shadowColor = UIColor.g2().cgColor
        superview?.layer.shadowOffset = CGSize(width: 0, height: 5)
        superview?.layer.shadowRadius = 4
        superview?.layer.shadowOpacity = 1.0
        superview?.layer.masksToBounds = false
    }

    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AllIcons.checkmark.rawValue)
        return imageView
    }()

    let accountIconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    let accountNameLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 20)
        lable.textColor = .g1()
        return lable
    }()

    let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: AllIcons.edit.rawValue), for: .normal)
        return button
    }()

    func setupLayout() {
        contentView.addSubview(checkmarkImageView)
        contentView.addSubview(accountIconImageView)
        contentView.addSubview(accountNameLable)
        contentView.addSubview(editButton)
        checkmarkImageView.snp.makeConstraints { mark in
            mark.width.height.equalTo(24)
            mark.centerY.equalTo(contentView)
            mark.leading.equalTo(12)
        }
        accountIconImageView.snp.makeConstraints { mark in
            mark.width.height.equalTo(48)
            mark.top.equalTo(contentView).offset(12)
            mark.bottom.equalTo(contentView).offset(-12)
            mark.leading.equalTo(checkmarkImageView.snp.trailing).offset(12)
        }

        accountNameLable.snp.makeConstraints { mark in
            mark.centerX.centerY.equalTo(contentView)
        }

        editButton.snp.makeConstraints { mark in
            mark.centerY.equalTo(contentView)
            mark.width.height.equalTo(24)
            mark.trailing.equalTo(contentView).offset(-20)
        }
    }

    func setButton() {
        editButton.addTarget(self, action: #selector(eaitActive), for: .touchUpInside)
    }

    @objc func eaitActive() {}
}
