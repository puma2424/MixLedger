//
//  SelectMemberViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/23.
//

import SnapKit
import UIKit

protocol SelectMemberViewControllerDelegate {
    func inputPayMemberMoney(cell: SelectMemberViewController)
    func inputShareMemberMoney(cell: SelectMemberViewController)
}

class SelectMemberViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTable()
        setupLayout()
        view.backgroundColor = UIColor(named: "G3")
        setButton()
        showTitleLabel.text = payOrShare?.title
    }

    var usersMoney: [String: Double]?

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    enum PayOrShare {
        case pay
        case share

        var title: String {
            switch self {
            case .pay:
                "輸入付款金額"
            case .share:
                "輸入分款金額"
            }
        }
    }

    var delegate: SelectMemberViewControllerDelegate?

    private let saveData = SaveData.shared

    var payOrShare: PayOrShare?

    let tableView = UITableView()

    let showTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("確      認", for: .normal)
        button.backgroundColor = UIColor(named: "G1")
        button.layer.cornerRadius = 10
        return button
    }()

    @objc func checkAction() {
        switch payOrShare {
        case .pay:
            delegate?.inputPayMemberMoney(cell: self)
        case .share:
            delegate?.inputShareMemberMoney(cell: self)
        case nil:
            return
        }
    }

    func setButton() {
        checkButton.addTarget(self, action: #selector(checkAction), for: .touchUpInside)
    }

    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SelectMemberTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor(named: "G3")
    }

    func setupLayout() {
        view.addSubview(showTitleLabel)
        view.addSubview(checkButton)
        view.addSubview(tableView)

        showTitleLabel.snp.makeConstraints { mark in
            mark.centerX.equalTo(view)
            mark.top.equalTo(view.safeAreaLayoutGuide).offset(12)
        }

        checkButton.snp.makeConstraints { mark in
            mark.width.equalTo(view.bounds.size.width * 0.8)
            mark.height.equalTo(50)
            mark.centerX.equalTo(view)
            mark.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }

        tableView.snp.makeConstraints { mark in
            mark.top.equalTo(showTitleLabel.snp.bottom).offset(12)
            mark.leading.equalTo(view.safeAreaLayoutGuide)
            mark.trailing.equalTo(view.safeAreaLayoutGuide)
            mark.bottom.equalTo(checkButton.snp.top).offset(-12)
        }
    }
}

extension SelectMemberViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        usersMoney?.keys.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        guard let memberCell = cell as? SelectMemberTableViewCell else { return cell }

        guard let usersMoney = usersMoney else { return cell }
        var userID: [String] = []
        for key in usersMoney.keys {
            userID.append(key)
        }

        if let userName = saveData.userInfoData.first { $0.userID == userID[indexPath.row] }?.name {
            memberCell.nameLabel.text = userName
        }
//        memberCell.nameLabel.text = saveData.userInfoData[userID[indexPath.row]]?.name
        if let money = usersMoney[userID[indexPath.row]] {
            memberCell.moneyTextField.text = "\(money)"
        }

        memberCell.changeMoney = { text in
            print(self.usersMoney)
            if let money = Double(text) {
                self.usersMoney?[userID[indexPath.row]] = money
                print(self.usersMoney)
            } else {
                print("失敗")
            }
        }

        return memberCell
    }
}
