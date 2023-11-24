//
//  InviteMessageTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/22.
//

import UIKit

class InviteMessageTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupLayout()
        setupButton()
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

    var agreeClosure: (() -> Void)?

    var rejectClosure: (() -> Void)?

    let inviteMessageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "lalalalallalalalalalalallalalalalalalalalal"
        return label
    }()

    let agreebutton: UIButton = {
        let button = UIButton()
        button.setTitle("接受", for: .normal)
        button.setTitleColor(UIColor(named: "G1"), for: .normal)
        button.backgroundColor = UIColor(named: "G3")
        button.layer.cornerRadius = 10
        return button
    }()

    let rejectButton: UIButton = {
        let button = UIButton()
        button.setTitle("拒絕", for: .normal)
        button.setTitleColor(UIColor(named: "G1"), for: .normal)
        button.backgroundColor = UIColor(named: "G3")
        button.layer.cornerRadius = 10
        return button
    }()

    @objc func agreeAction() {
        print("接受")
        agreeClosure?()
    }

    @objc func rejectAvtion() {
        print("拒絕")
        rejectClosure?()
    }

    func setupButton() {
        agreebutton.addTarget(self, action: #selector(agreeAction), for: .touchUpInside)
        rejectButton.addTarget(self, action: #selector(rejectAvtion), for: .touchUpInside)
    }

    func setupLayout() {
        contentView.addSubview(rejectButton)
        contentView.addSubview(agreebutton)
        contentView.addSubview(inviteMessageLabel)

        inviteMessageLabel.snp.makeConstraints { mark in
            mark.top.equalTo(contentView).offset(12)
            mark.leading.equalTo(contentView).offset(12)
            mark.bottom.equalTo(contentView).offset(-12)
            mark.trailing.equalTo(agreebutton.snp.leading).offset(-12)
        }

        agreebutton.snp.makeConstraints { mark in
            mark.width.equalTo(80)
            mark.height.equalTo(25)
            mark.top.equalTo(contentView).offset(12)
            mark.trailing.equalTo(rejectButton.snp.leading).offset(-12)
        }

        rejectButton.snp.makeConstraints { mark in
            mark.width.equalTo(80)
            mark.height.equalTo(25)
            mark.top.equalTo(contentView).offset(12)
            mark.trailing.equalTo(contentView).offset(-8)
        }
    }
}
