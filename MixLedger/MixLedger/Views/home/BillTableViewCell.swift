//
//  BillTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/16.
//

import SnapKit
import UIKit
class BillTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    // 如果是使用 Interface Builder，這個初始化方法會被呼叫
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // 共用的初始化邏輯
    private func commonInit() {
        // 在這裡放置需要在初始化時執行的程式碼
//        setupView()
        setView()
        backgroundColor = .g3()
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        // 在 tableView 的父视图中设置阴影
//        superview?.layer.shadowColor = UIColor.g2().cgColor
//        superview?.layer.shadowOffset = CGSize(width: 0, height: 5)
//        superview?.layer.shadowRadius = 4
//        superview?.layer.shadowOpacity = 1.0
//        superview?.layer.masksToBounds = false
//    }

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

    func setView() {
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = .g1()
        moneyLabel.font = UIFont.systemFont(ofSize: 18)
        moneyLabel.textColor = .g1()

        moneyLabel.textAlignment = .right

        moneyLabel.numberOfLines = 1
        titleLabel.numberOfLines = 1
        contentView.addSubview(sortImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(moneyLabel)

        sortImageView.snp.makeConstraints { mark in
            mark.width.height.equalTo(50)
            mark.leading.equalTo(contentView).offset(5)
            mark.centerY.equalTo(contentView)
            mark.bottom.equalTo(contentView).offset(-5)
        }

        titleLabel.snp.makeConstraints { mark in
            mark.centerY.equalTo(contentView)
            mark.leading.equalTo(sortImageView.snp.trailing).offset(12)
            mark.trailing.lessThanOrEqualTo(moneyLabel.snp.leading).offset(-8) // 設置 titleStackView 右邊不超過 moneyStackView 的左邊
        }

        moneyLabel.snp.makeConstraints { mark in
            mark.centerY.equalTo(contentView)
            mark.trailing.equalTo(contentView.snp.trailing).offset(-12)
        }
    }

    func setupView() {
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleNoteLabel.font = UIFont.systemFont(ofSize: 13)
        moneyLabel.font = UIFont.systemFont(ofSize: 15)
        moneyNoteLabel.font = UIFont.systemFont(ofSize: 13)

        moneyLabel.textAlignment = .right
        moneyNoteLabel.textAlignment = .right

        moneyLabel.numberOfLines = 1
        moneyNoteLabel.numberOfLines = 1
        titleNoteLabel.numberOfLines = 0
        titleLabel.numberOfLines = 1
        contentView.addSubview(sortImageView)
        contentView.addSubview(titleStackView)
        contentView.addSubview(moneyStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleNoteLabel)
        moneyStackView.addArrangedSubview(moneyLabel)
        moneyStackView.addArrangedSubview(moneyNoteLabel)

        sortImageView.snp.makeConstraints { mark in
            mark.width.height.equalTo(50)
            mark.leading.equalTo(contentView).offset(2)
            mark.centerY.equalTo(contentView)
        }

        titleStackView.snp.makeConstraints { mark in
            mark.top.equalTo(sortImageView).offset(5)
            mark.leading.equalTo(sortImageView.snp.trailing).offset(2)
            mark.trailing.lessThanOrEqualTo(moneyStackView.snp.leading).offset(-8) // 設置 titleStackView 右邊不超過 moneyStackView 的左邊
            mark.bottom.equalTo(contentView).offset(-5)
        }

        moneyStackView.snp.makeConstraints { mark in
            mark.width.equalTo(80)
            mark.top.equalTo(sortImageView).offset(5)
            mark.trailing.equalTo(contentView.snp.trailing).offset(-5)
        }
    }
}
