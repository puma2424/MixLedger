//
//  ANIMemberTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import SnapKit
import UIKit

class ANIMemberTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTable()
        setupLayout()
        backgroundColor = .g3()
//        memberInfo()
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

//    var uses: [UsersInfoResponse] = []

    var usersMoney: [String: Double]? {
        didSet {
            tableView.reloadData()
        }
    }

    let saveData = SaveData.shared

    let showTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .g1()
        return label
    }()

    let tableView = UITableView()

    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .g3()
        tableView.register(ShowMemberTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupLayout() {
        addSubview(showTitleLabel)
        addSubview(tableView)

        showTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(12)
            make.leading.equalTo(self).offset(12)
//            make.centerY.equalTo(self)
        }

        let tableHeight = (saveData.accountData?.shareUsersID?.count ?? 0) * 45

        tableView.snp.makeConstraints { mark in
            mark.top.equalTo(self)
            mark.leading.equalTo(showTitleLabel.snp.trailing).offset(12)
            mark.bottom.equalTo(self)
            mark.trailing.equalTo(self)
            mark.height.equalTo(tableHeight)
        }
    }
}

extension ANIMemberTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        usersMoney?.keys.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        guard let searchCell = cell as? ShowMemberTableViewCell else { return cell }
        guard let usersMoney = usersMoney else { return cell }
        var userID: [String] = []
        for key in usersMoney.keys {
            userID.append(key)
        }

        if let userName = saveData.userInfoData.first(where: { $0.userID == userID[indexPath.row] })?.name {
            searchCell.nameLabel.text = userName
        }

        if let money = usersMoney[userID[indexPath.row]] {
            searchCell.moneyLabel.text = "\(money)"
        }

        return searchCell
    }
}
