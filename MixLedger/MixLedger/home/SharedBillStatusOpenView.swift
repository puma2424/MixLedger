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
    func addRePayView(subview: RepayView)
}

class SharedBillStatusOpenView: SharedBillStatusSmallView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTable()
        setpuLayout()
//        adjustDate(by: 0)
        backgroundColor = .white
        setButtonTarge()
        setupButton()
        backgroundColor = .brightGreen4()
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
    let firebaseManager = FirebaseManager.shared
    var openDelegate: SharedBillStatusOpenViewDelegate?
    var table = UITableView()
    var myMoney: Double = 0

    var usersInfo: [UsersInfoResponse] = [] {
        didSet {
            table.reloadData()
        }
    }

    var billStatus: [[String: Double]]? {
        didSet {
            let myID = saveData.myInfo?.userID ?? ""
            if let index = billStatus?.firstIndex(where: { $0.keys.contains(myID) }), let money = billStatus?[index][myID] {
                myMoney = money
            }
            return
        }
    }

    func setupTable() {
        table = UITableView(frame: bounds, style: .insetGrouped)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .brightGreen4()
        table.register(SBSVUsersTableViewCell.self, forCellReuseIdentifier: "userCell")
    }

    func setupButton() {
        if let image = UIImage(systemName: "triangle.fill") {
            let rotatedImage = image.rotate(radians: 0)
            openOrCloseButton.setImage(rotatedImage, for: .normal)
        }
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

extension SharedBillStatusOpenView: SBSVUsersTableViewCellDelegate {
    func checkButtonTarget(cell: SBSVUsersTableViewCell) {
        if let indexPath = table.indexPath(for: cell) {
            let id = usersInfo[indexPath.row].userID
            print(id)

            if cell.amount.checkButtonTitle == "催  款" {
                if let index = billStatus?.firstIndex(where: { $0.keys.contains(id) }), let money = billStatus?[index][id] {
                    print("\(billStatus?[index][id])")
                    guard let myName = saveData.myInfo?.name else { return }
                    guard let otherUserName = usersInfo.first(where: { $0.userID == id })?.name else { return }
//                    guard let otherUserName = usersInfo?[id].name else {return}
                    guard let accountData = saveData.accountData else { return }

                    let toOutherText = "\(myName)從\"\(accountData.accountName)\"傳送訊息給您：\n 請還款\(abs(money))"
                    let myText = "從\"\(accountData.accountName)\"傳送訊息給\(otherUserName):\n請還款\(abs(money))"

                    firebaseManager.postMessage(toUserID: id,
                                                textToOtherUser: toOutherText,
                                                textToMyself: myText,
                                                isDunningLetter: false,
                                                amount: 0.0,
                                                fromAccoundID: accountData.accountID,
                                                fromAccoundName: accountData.accountName)
                    { _ in
                    }
                }
            } else if cell.amount.checkButtonTitle == "還  款" {
                if let index = billStatus?.firstIndex(where: { $0.keys.contains(id) }), let money = billStatus?[index][id] {
                    print(cell.amount.checkButtonTitle)
                    let repayView = RepayView()
                    repayView.otherMoney = money
                    guard let otherUserName = usersInfo.first(where: { $0.userID == id })?.name else { return }
//                    guard let otherUserName = usersInfo?[id]?.name else {return}
                    repayView.otherUserName = otherUserName
                    repayView.otherUserID = id

                    repayView.setLabel(otherUserName: otherUserName, otherMoney: "\(abs(money))")
                    openDelegate?.addRePayView(subview: repayView)
                }
            }
        }
    }
}

extension SharedBillStatusOpenView: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        usersInfo.count
//    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return usersInfo.count /* 1 */
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.selectionStyle = .none
        guard let userCell = cell as? SBSVUsersTableViewCell else { return cell }
        userCell.delegate = self
//        let userInfo = usersInfo[indexPath.section]
        let userInfo = usersInfo[indexPath.row]

        let id = userInfo.userID
        userCell.nameLable.text = userInfo.name
        userCell.userImage.image = UIImage(named: userInfo.iconName)
        if let index = billStatus?.firstIndex(where: { $0.keys.contains(id) }),
           let userMoney = billStatus?[index][id]
        {
            let amount = MoneyType.money(userMoney)
            userCell.amount = amount
            if id == saveData.myInfo?.userID {
//                userCell.checkButton.isHidden = true
                userCell.setupNoButtonLayout()
                myMoney = userMoney
            } else {
                if myMoney < 0 && userMoney < 0 {
//                    userCell.checkButton.isHidden = true
                    userCell.setupNoButtonLayout()
                } else if myMoney < 0 && userMoney > 0 {
//                    userCell.checkButton.isHidden = false
                    userCell.setupHaveButtonView()
                    userCell.checkButton.setTitle(amount.checkButtonTitle, for: .normal)
                } else if myMoney > 0 && userMoney < 0 {
//                    userCell.checkButton.isHidden = false
                    userCell.setupHaveButtonView()
                    userCell.checkButton.setTitle(amount.checkButtonTitle, for: .normal)
                } else if myMoney > 0 && userMoney > 0 {
//                    userCell.checkButton.isHidden = true
                    userCell.setupNoButtonLayout()
                } else if myMoney == 0 || userMoney == 0 {
//                    userCell.checkButton.isHidden = true
                    userCell.setupNoButtonLayout()
                }
            }

            let money = abs(userMoney)
            let moneyString = String(format: "%.1f", money)

            userCell.moneyLable.text = "\(moneyString)"
            userCell.moneyLable.textColor = amount.color
            userCell.statusLable.text = amount.billTitle
            userCell.statusLable.textColor = amount.color
        }

        return userCell
    }
}
