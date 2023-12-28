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
    
    func handleDunningButton(id: String) {
        if let index = billStatus?.firstIndex(where: { $0.keys.contains(id) }),
            let money = billStatus?[index][id] {
            
            // 檢查所需的資料是否有效
            guard let myName = saveData.myInfo?.name,
                  let otherUserName = usersInfo.first(where: { $0.userID == id })?.name,
                  let accountData = saveData.accountData else {
                LKProgressHUD.showFailure()
                return
            }
            
            // 構建催款訊息
            let toOutherText = "\(myName)從\"\(accountData.accountName)\"傳送訊息給您：\n 請還款\(abs(money))"
            let myText = "從\"\(accountData.accountName)\"傳送訊息給\(otherUserName):\n請還款\(abs(money))"
            
            // 創建傳送訊息的模型
            let message = Message(toSenderMessage: myText,
                                  toReceiverMessage: toOutherText,
                                  fromUserID:  saveData.myInfo?.userID ?? "",
                                  isDunningLetter: false,
                                  amount: 0.0,
                                  toUserID: id,
                                  formAccoundID: accountData.accountID,
                                  fromAccoundName: accountData.accountName)
            
            // 使用 firebaseManager 傳送訊息
            firebaseManager.postMessage(message: message) { result in
                switch result {
                case .success(_):
                    LKProgressHUD.showSuccess(text: "訊息已發送")
                case .failure(_):
                    LKProgressHUD.showFailure(text: "訊息發送失敗")
                }
            }
        }
    }
}

extension SharedBillStatusOpenView: SBSVUsersTableViewCellDelegate {
    func checkButtonTarget(cell: SBSVUsersTableViewCell) {
        if let indexPath = table.indexPath(for: cell) {
            let id = usersInfo[indexPath.row].userID
            print(id)

            if cell.amount.checkButtonTitle == "催  款" {
                handleDunningButton(id: id)
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
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return usersInfo.count 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.selectionStyle = .none
        guard let userCell = cell as? SBSVUsersTableViewCell else { return cell }
        userCell.delegate = self
        let userInfo = usersInfo[indexPath.row]

        let id = userInfo.userID
        
        userCell.nameLabel.text = userInfo.name
        userCell.userImage.image = UIImage(named: userInfo.iconName)
        
        if let index = billStatus?.firstIndex(where: { $0.keys.contains(id) }),
           let userMoney = billStatus?[index][id] {
            
            userCell.amount = MoneyType.money(userMoney)
            if id == saveData.myInfo?.userID {
                userCell.setupNoButtonLayout()
                myMoney = userMoney
            } else {
                if myMoney < 0 && userMoney < 0 {
                    userCell.setupNoButtonLayout()
                } else if myMoney < 0 && userMoney > 0 {
                    userCell.setupHaveButtonView()
                } else if myMoney > 0 && userMoney < 0 {
                    userCell.setupHaveButtonView()
                } else if myMoney > 0 && userMoney > 0 {
                    userCell.setupNoButtonLayout()
                } else if myMoney == 0 || userMoney == 0 {
                    userCell.setupNoButtonLayout()
                }
            }

            let money = abs(userMoney)
            let moneyString = String(format: "%.1f", money)

            userCell.moneyLabel.text = "\(moneyString)"
            userCell.updateUIWithAmount()
        }

        return userCell
    }
}
