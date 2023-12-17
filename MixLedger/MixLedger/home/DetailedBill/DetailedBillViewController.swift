//
//  DetailedBillViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/11.
//

import UIKit

class DetailedBillViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTable()
        setupLayout()
        view.backgroundColor = .brightGreen4()
        numberOfUser()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    var data: Transaction?
    
    var allUsers: [String: Double] = [: ]
    
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        return table
    }()
    
    var idOfPayUser: [String] = []
    var idOfShareUser: [String] = []
    func numberOfUser() {
        guard let data = data else { return }
        
        if let payUser = data.payUser,
        let shareUser = data.shareUser {
            
            for id in payUser.keys where payUser[id] ?? 0.0 > 0.0 {
                idOfPayUser.append(id)
            }
            
            for id in shareUser.keys where shareUser[id] ?? 0.0 > 0.0 {
                idOfShareUser.append(id)
            }
        }
    }
    
    func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(DetailedBillTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view)
        }
    }
}

extension DetailedBillViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 + idOfPayUser.count + idOfShareUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        guard let detailCell = cell as? DetailedBillTableViewCell  else { return cell }
        // Configure cells based on indexPath.row
        guard let data = data else { return cell }
        
            switch indexPath.row {
            case 0:
                detailCell.iconImageView.image = AllIcons.moneyAndCoin.icon
                detailCell.contentLabel.text = "\(data.amount)"
            case 1:
                detailCell.iconImageView.image = UIImage(named: data.subType.iconName)
                detailCell.contentLabel.text = data.subType.name
            case 2:
                detailCell.iconImageView.image = AllIcons.receipt.icon
                detailCell.contentLabel.text = data.note
            case 3:
                detailCell.iconImageView.image = AllIcons.date.icon
                detailCell.contentLabel.text = "\(data.date)"
            case 4:
                detailCell.iconImageView.image = AllIcons.importIcon.icon
                if let from = data.from {
                    detailCell.contentLabel.text = "\(from)"
                }
            default:
                detailCell.setupForUserLayout()
                if indexPath.row <= idOfPayUser.count + 4 {
                    detailCell.iconImageView.image = AllIcons.human.icon
                    if idOfPayUser.count > 0 {
                        let id = idOfPayUser[indexPath.row - 5]
                        
                        var name = SaveData.shared.userInfoData.filter { user in
                            user.userID == id
                        }
                        if name.count > 0,
                        let amount = data.payUser?[id] {
                            detailCell.contentLabel.text = name[0].name
                            
                            let moneyType = MoneyType.money(amount)
                            detailCell.moneyLabel.text = moneyType.text
                            detailCell.payOrShareLabel.text = "Pay"
                            
                            detailCell.moneyLabel.textColor = moneyType.color
                            detailCell.payOrShareLabel.textColor = moneyType.color
                        }
                    }
                } else if indexPath.row <= idOfPayUser.count + idOfShareUser.count + 4 {
                    detailCell.iconImageView.image = AllIcons.human.icon
                    if idOfShareUser.count > 0 {
                        let id = idOfShareUser[indexPath.row - 5 - idOfPayUser.count]
                        
                        var name = SaveData.shared.userInfoData.filter { user in
                            user.userID == id
                        }
                        
                        if name.count > 0,
                           let amount = data.shareUser?[id] {
                            detailCell.contentLabel.text = name[0].name 
                            let moneyType = MoneyType.money(-amount)
                            detailCell.moneyLabel.text = moneyType.text
                            detailCell.payOrShareLabel.text = "Share"
                            
                            detailCell.moneyLabel.textColor = moneyType.color
                            detailCell.payOrShareLabel.textColor = moneyType.color
                        }
                    }
                }
            }
        if detailCell.contentLabel.text == "" || detailCell.contentLabel.text == nil {
            detailCell.contentLabel.textColor = .gray
            detailCell.contentLabel.text = "Nothing"
        } else {
            detailCell.contentLabel.textColor = .g1()
        }
        return detailCell
    }
}
