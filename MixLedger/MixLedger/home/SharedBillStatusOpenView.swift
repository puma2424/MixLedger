//
//  SharedBillStatusOpenView.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/16.
//

import SnapKit
import UIKit
protocol SharedBillStatusOpenViewDelegate {
    func closeView()
    func inputData(view: SharedBillStatusOpenView)
}

class SharedBillStatusOpenView: SharedBillStatusSmallView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        openDelegate?.inputData(view: self)
        setpuLayout()
//        adjustDate(by: 0)
        backgroundColor = .white
        setButtonTarge()
        setupTable()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
         // Drawing code
     }
     */
//    var users: [UsersInfo]? = nil
    let saveData = SaveData.shared
    var openDelegate: SharedBillStatusOpenViewDelegate?
    let table = UITableView()
    var userID: [String] = []

    var usersInfo: [String: UsersInfoResponse]? {
        didSet {
            userID = []
            if let userInfo = usersInfo {
                for key in userInfo.keys {
                    userID.append(key)
                }
            }

            print(usersInfo)
            table.reloadData()
        }
    }

    var billStatus: [[String: Double]]? {
        didSet {
            return
        }
    }

    func setupTable() {
        table.delegate = self
        table.dataSource = self
        table.register(SBSVUsersTableViewCell.self, forCellReuseIdentifier: "userCell")
    }

    override func setpuLayout() {
        super.setpuLayout()
        addSubview(table)
        table.snp.makeConstraints { mark in
            mark.top.equalTo(self).offset(5)
            mark.leading.equalTo(self)
            mark.trailing.equalTo(self)
            mark.bottom.equalTo(openOrCloseButton.snp.top)
        }
    }

    @objc override func openOrCloseActive() {
        openDelegate?.closeView()
    }
}

extension SharedBillStatusOpenView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return userID.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        guard let userCell = cell as? SBSVUsersTableViewCell else { return cell }
        if let userInfo = usersInfo {
            let id = userID[indexPath.row]
            userCell.nameLable.text = userInfo[id]?.name
//            userCell.moneyLable.text = "\(billStatus?[userID[indexPath.row]])"

            if let index = billStatus?.firstIndex(where: { $0.keys.contains(id) }) {
                userCell.moneyLable.text = "\(billStatus?[index][id])"
            }
        }

        return userCell
    }
}
