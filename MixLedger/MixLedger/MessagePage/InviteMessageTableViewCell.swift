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
        self.backgroundColor = .brightGreen4()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        label.text = "la"
        label.textColor = .g1()
        return label
    }()

    let agreebutton: UIButton = {
        let button = UIButton()
        button.setTitle("確 認", for: .normal)
        button.setTitleColor(.g3(), for: .normal)
        button.backgroundColor = .brightGreen3()
        button.layer.cornerRadius = 10
        return button
    }()

    let rejectButton: UIButton = {
        let button = UIButton()
        button.setTitle("拒 絕", for: .normal)
        button.setTitleColor(.g3(), for: .normal)
        button.backgroundColor = .brightGreen3()
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
    
    func setupLayoutJustAgreeButton() {
//        agreebutton.setTitle("確  認", for: .normal)
        rejectButton.removeFromSuperview()
        agreebutton.removeFromSuperview()
        contentView.addSubview(agreebutton)
        inviteMessageLabel.snp.remakeConstraints { mark in
            mark.top.equalTo(contentView).offset(12)
            mark.leading.equalTo(contentView).offset(12)
            mark.trailing.equalTo(contentView).offset(-12)
        }
        
        agreebutton.snp.makeConstraints { mark in
            mark.leading.equalTo(contentView).offset(12)
            mark.trailing.equalTo(contentView).offset(-12)
            mark.height.equalTo(45)
            mark.top.equalTo(inviteMessageLabel.snp.bottom).offset(12)
            mark.bottom.equalTo(contentView).offset(-12)
        }
    }

    func setupLayoutIncludeBothButton() {
        rejectButton.removeFromSuperview()
        agreebutton.removeFromSuperview()
        contentView.addSubview(rejectButton)
        contentView.addSubview(agreebutton)
        inviteMessageLabel.snp.remakeConstraints { mark in
            mark.top.equalTo(contentView).offset(12)
            mark.leading.equalTo(contentView).offset(12)
            mark.trailing.equalTo(contentView).offset(-12)
        }
        
        rejectButton.snp.makeConstraints { mark in
            mark.leading.equalTo(contentView).offset(12)
            mark.trailing.equalTo(contentView.snp.centerX).offset(-6)
            mark.height.equalTo(45)
            mark.top.equalTo(inviteMessageLabel.snp.bottom).offset(12)
            mark.bottom.equalTo(contentView).offset(-12)
        }

        agreebutton.snp.makeConstraints { mark in 
            mark.height.equalTo(45)
            mark.top.equalTo(inviteMessageLabel.snp.bottom).offset(12)
            mark.leading.equalTo(contentView.snp.centerX).offset(6)
            mark.trailing.equalTo(contentView).offset(-12)
        }
    }
    
    func setupLayoutNoButton() {
        rejectButton.removeFromSuperview()
        agreebutton.removeFromSuperview()
//        contentView.addSubview(rejectButton)
//        contentView.addSubview(agreebutton)
//        contentView.addSubview(inviteMessageLabel)

        inviteMessageLabel.snp.remakeConstraints { mark in
            mark.top.equalTo(contentView).offset(12)
            mark.leading.equalTo(contentView).offset(12)
            mark.trailing.equalTo(contentView).offset(-12)
            mark.bottom.equalTo(contentView).offset(-12)
        }

    }
    
    func setupLayout() {
        contentView.addSubview(rejectButton)
        contentView.addSubview(agreebutton)
        contentView.addSubview(inviteMessageLabel)

        inviteMessageLabel.snp.makeConstraints { mark in
            mark.top.equalTo(contentView).offset(12)
            mark.leading.equalTo(contentView).offset(12)
            mark.trailing.equalTo(contentView).offset(-12)
        }

        rejectButton.snp.makeConstraints { mark in
            mark.width.equalTo(100)
            mark.height.equalTo(45)
            mark.top.equalTo(inviteMessageLabel.snp.bottom).offset(12)
            mark.bottom.equalTo(contentView).offset(-12)
            mark.centerX.equalTo(contentView).offset(-62)
        }

        agreebutton.snp.makeConstraints { mark in
            mark.width.equalTo(100)
            mark.height.equalTo(45)
            mark.top.equalTo(inviteMessageLabel.snp.bottom).offset(12)
            mark.centerX.equalTo(contentView).offset(62)
        }
    }
}
