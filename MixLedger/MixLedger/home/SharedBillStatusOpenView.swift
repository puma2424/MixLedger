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
        setpuLayout()
//        adjustDate(by: 0)
        backgroundColor = .white
        setButtonTarge()
        setupButton()
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
    let firebaseManager = FirebaseManager.shared
    var openDelegate: SharedBillStatusOpenViewDelegate?
    let table = UITableView()
    var userID: [String] = []
    var myMoney: Double = 0
    
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
            let myID = saveData.myInfo?.userID ?? ""
            if let index = billStatus?.firstIndex(where: { $0.keys.contains(myID) }), let money = billStatus?[index][myID] {
                myMoney = money
            }
            return
        }
    }

    func setupTable() {
        table.delegate = self
        table.dataSource = self
        table.register(SBSVUsersTableViewCell.self, forCellReuseIdentifier: "userCell")
    }

    func setupButton(){
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

extension SharedBillStatusOpenView: SBSVUsersTableViewCellDelegate{
    func checkButtonTarget(cell: SBSVUsersTableViewCell) {
        if let indexPath = table.indexPath(for: cell){
            let id = userID[indexPath.row]
            print(id)
            
            if cell.amount.checkButtonTitle == "催款"{
                if let index = billStatus?.firstIndex(where: { $0.keys.contains(id) }), let money = billStatus?[index][id] {
                    print("\(billStatus?[index][id])")
                    guard let myName = saveData.myInfo?.name else {return}
                    guard let accountName = saveData.accountData?.accountName else {return}
                    guard let otherUserName = usersInfo?[id]?.name else {return}
                    let toOutherText = "\(myName)從\"\(accountName)\"傳送訊息給您：\n 請還款\(abs(money))"
                    let myText = "從\"\(accountName)\"傳送訊息給\(otherUserName):\n請還款\(abs(money))"
                    firebaseManager.postMessage(toUserID: id, text: [toOutherText,myText]){_ in
                        return
                    }
                }
            }else if cell.amount.checkButtonTitle == "還款"{
                if let index = billStatus?.firstIndex(where: { $0.keys.contains(id) }), let money = billStatus?[index][id] {
                    print(cell.amount.checkButtonTitle)
                    let repayView = RepayView()
                    repayView.otherMoney = money
                    guard let otherUserName = usersInfo?[id]?.name else {return}
                    repayView.otherUserName = otherUserName
                    repayView.otherUserID = id
                    
                    repayView.titleLabel.text = "\(otherUserName)待收款金額為：\(abs(money))"
                    repayView.toUser.text = "向\(otherUserName)還款"
                    openDelegate?.addRePayView(subview: repayView)
                }
                
                
            }
            

        }
//        table.reloadData()
    }
}

extension SharedBillStatusOpenView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return userID.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        guard let userCell = cell as? SBSVUsersTableViewCell else { return cell }
        userCell.delegate = self
        if let userInfo = usersInfo {
            let id = userID[indexPath.row]
            
           
            
            
            userCell.nameLable.text = userInfo[id]?.name
//            userCell.moneyLable.text = "\(billStatus?[userID[indexPath.row]])"
            
            if let index = billStatus?.firstIndex(where: { $0.keys.contains(id) }), let userMoney = billStatus?[index][id] {
                let amount = MoneyType.money(userMoney)
                userCell.amount = amount
                if id == saveData.myInfo?.userID {
                    userCell.checkButton.isHidden = true
                    myMoney = userMoney
                }else {
                    if myMoney < 0 && userMoney < 0 {
                        userCell.checkButton.isHidden = true
                    }else if myMoney < 0 && userMoney > 0{
                        userCell.checkButton.isHidden = false
                        userCell.checkButton.setTitle(amount.checkButtonTitle, for: .normal)
                    }else if myMoney > 0 && userMoney < 0{
                        userCell.checkButton.isHidden = false
                        userCell.checkButton.setTitle(amount.checkButtonTitle, for: .normal)
                    }else if myMoney > 0 && userMoney > 0{
                        userCell.checkButton.isHidden = true
                    }
                    
                }
                
                
                userCell.moneyLable.text = "\(amount.billTitle) \(abs(userMoney))"
                userCell.moneyLable.textColor = amount.color
            }
        }

        return userCell
    }
}
