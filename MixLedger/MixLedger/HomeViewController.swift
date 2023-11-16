//
//  ViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/14.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController{
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "我的帳本"
        setuupLayout()
        setupTable()
        
        
        
    }
    
    let billStatus = SharedBillStatusSmallView()
    
    let billTable = UITableView()
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add"), for: .normal)
        return button
    }()
    
    func setupButton(){
        addButton.addTarget(self, action: #selector(addNewBill), for: .touchUpInside)
    }
    @objc func addNewBill(){
        
    }
    func setupTable(){
        billTable.delegate = self
        billTable.dataSource = self
        billTable.register(BillTableViewCell.self, forCellReuseIdentifier: "billCell")
    }
    
    func setuupLayout(){
        billStatus.layer.cornerRadius = 10
        view.addSubview(billStatus)
        view.addSubview(billTable)
        view.addSubview(addButton)
        billStatus.snp.makeConstraints{(make) in
            make.width.equalTo(view.bounds.size.width * 0.9)
            make.height.equalTo(110)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        billTable.snp.makeConstraints{(make) in
            make.centerX.equalTo(view)
            make.top.equalTo(billStatus.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(view.safeAreaLayoutGuide)
        }
        
        addButton.snp.makeConstraints{(make) in
            
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.width.height.equalTo(80)
        }
    }
    struct BillTag{
        var icon: UIImage?
        var name: String
    }
    
    //struct billItem{
    //}
    var billArray: [[String: [Any]]] = [["日期": [Date()],
                                         "item": [["金額": -3000000,
                                                   "付費者": ["puma","niw"],
                                                   "分費者": ["puma"],
                                                   "備註": "草莓欸",
                                                   "幣別": "新台幣",
                                                   "類型": BillTag(icon: UIImage(named: "more"), name: "飲食"),
                                                   "照片": UIImage(named: "more"),
                                                   "from":""],
                                                  ["金額": -300,
                                                   "付費者": ["puma","niw"],
                                                   "分費者": ["puma"],
                                                   "備註": "草莓好好吃誒誒誒誒誒誒誒誒誒誒欸誒誒誒誒誒誒誒誒誒",
                                                   "幣別": "新台幣",
                                                   "類型": BillTag(icon: UIImage(named: "more"), name: "飲食"),
                                                   "照片": UIImage(named: "more"),
                                                   "from":""]]
                                        ],
                                        ["日期": [Date()],
                                         "item": [["金額": 3000000,
                                                   "付費者": ["puma","niw"],
                                                   "分費者": ["puma"],
                                                   "備註": "草莓欸",
                                                   "幣別": "新台幣",
                                                   "類型": BillTag(icon: UIImage(named: "more"), name: "飲食"),
                                                   "照片": UIImage(named: "more"),
                                                   "from":""],
                                                  ["金額": 300,
                                                   "付費者": ["puma","niw"],
                                                   "分費者": ["puma"],
                                                   "備註": "草莓好好吃誒誒誒誒誒誒誒誒誒誒欸誒誒誒誒誒誒誒誒誒",
                                                   "幣別": "新台幣",
                                                   "類型": BillTag(icon: UIImage(named: "more"), name: "飲食"),
                                                   "照片": UIImage(named: "more"),
                                                   "from":""]]
                                        ]
    ]
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let bill = billArray[section]
        return bill["item"]?.count ?? 0
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return billArray.count
    }
    func tableView(tableView: UITableView,
      heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFont = DateFormatter()
        dateFont.dateFormat = "yyyy-MM-dd"
        if let date = billArray[section]["日期"]?[0] as? Date{
            let dateString = dateFont.string(from: date)
            print(dateString)
            return dateString
        }else{
            return ""
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = billTable.dequeueReusableCell(withIdentifier: "billCell", for: indexPath)
        guard let billCell = cell as? BillTableViewCell else { return cell }
        let datas = billArray[indexPath.row]["item"]
        if let data = datas?[indexPath.row] as? [String: Any] {
            if let money = data["金額"] as? Int {
                let moneyType: MoneyType = .money(Double(money))
                billCell.moneyLabel.text = moneyType.text
                billCell.moneyLabel.textColor = moneyType.color
            }
            if let moneyNote = data["幣別"] as? String {
                billCell.moneyNoteLabel.text = moneyNote
            }
            if let title = data["類型"] as? BillTag {
                billCell.titleLabel.text = title.name
                billCell.sortImageView.image = title.icon
            }
            if let titleNote = data["備註"] as? String , let pay = data["付費者"] as? [String]{
                var note = ""
                pay.forEach{note += "\($0) "}
                note += "/\(titleNote)"
                billCell.titleNoteLabel.text = note
            }
            
        }
        
        
        return cell
    }
}
