//
//  AddNewItemViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import UIKit
import SnapKit
class AddNewItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "G3")
        setLayout()
        setTable()
        setCheckButton()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    let firebase = FirebaseManager.shared
    var amount: Double?
    var member: String?
    var selectDate: Date?
    var type: TransactionType?
    
    let table = UITableView()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: AllIcons.close.rawValue), for: .normal)
        return button
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "G2")
        return view
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("確      認", for: .normal)
        button.backgroundColor = UIColor(named: "G1")
        button.layer.cornerRadius = 10
        return button
    }()
    
    @objc func checkButtonActive(){
        if amount == nil {
            
        }else{
            let type = TransactionType(iconName: AllIcons.edit.rawValue, name: "讀書")
            firebase.postData(amount: amount ?? 0 , date: selectDate ?? Date(), payUser: ["QJeplpxVXBca5xhXWgbT"], shareUser: ["QJeplpxVXBca5xhXWgbT"], note: "你想活出怎樣的人生", type: type){ result in
                
            }
            
        }
        
    }
    
    func setCheckButton(){
        checkButton.addTarget(self, action: #selector(checkButtonActive), for: .touchUpInside)
    }
    
    func setTable(){
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.register(ANIMoneyTableViewCell.self, forCellReuseIdentifier: "moneyCell")
        table.register(ANITypeTableViewCell.self, forCellReuseIdentifier: "typeCell")
        table.register(ANIMemberTableViewCell.self, forCellReuseIdentifier: "memberCell")
        table.register(ANISelectDateTableViewCell.self, forCellReuseIdentifier: "dateCell")
    }
    
    func setLayout(){
        view.addSubview(table)
        view.addSubview(lineView)
        view.addSubview(checkButton)
        view.addSubview(closeButton)
        
        
        closeButton.snp.makeConstraints{(mark) in
            mark.width.height.equalTo(24)
            mark.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            mark.leading.equalTo(view.safeAreaLayoutGuide).offset(12)
        }
        
        lineView.snp.makeConstraints{(mark) in
            mark.height.equalTo(1)
            mark.width.equalTo(view.bounds.size.width * 0.9)
            mark.top.equalTo(closeButton.snp.bottom).offset(12)
            mark.centerX.equalTo(view)
        }
        
        checkButton.snp.makeConstraints{(mark) in
            mark.width.equalTo(view.bounds.size.width * 0.8)
            mark.height.equalTo(50)
            mark.centerX.equalTo(view)
            mark.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
        
        table.snp.makeConstraints{(mark) in
            mark.top.equalTo(lineView.snp.bottom)
            mark.leading.equalTo(view)
            mark.bottom.equalTo(checkButton.snp.top)
            mark.trailing.equalTo(view)
        }
    }
}

extension AddNewItemViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "moneyCell", for: indexPath)
            guard let monryCell = cell as? ANIMoneyTableViewCell else { return cell }
            monryCell.iconImageView.image = UIImage(named: AllIcons.moneyAndCoin.rawValue)
            monryCell.inputText.addTarget(self, action: #selector(getAmount(_:)), for: .editingChanged)
            
        }else if indexPath.row == 1{
            
            cell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath)
            guard let typeCell = cell as? ANITypeTableViewCell else { return cell }
            typeCell.iconImageView.image = UIImage(named: AllIcons.foodRice.rawValue)
            
            if let text =  typeCell.inputText.text{
                type?.name = text
            }
            
            
            
            
        }else if indexPath.row == 2{
            cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            guard let dateCell = cell as? ANISelectDateTableViewCell else { return cell }
            dateCell.iconImageView.image = UIImage(named: AllIcons.person.rawValue)
             selectDate = dateCell.datePicker.date
            dateCell.datePicker.addTarget(self, action: #selector(datePickerDidChange(_:)), for: .valueChanged)
            
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
            guard let typeCell = cell as? ANIMemberTableViewCell else { return cell }
            typeCell.iconImageView.image = UIImage(named: AllIcons.person.rawValue)
        }
        return cell
    }
    
        @objc func getAmount(_ textField: UITextField) {
            amount = Double(textField.text ?? "")
        }

        // DatePicker 的值變化時的動作
        @objc func datePickerDidChange(_ datePicker: UIDatePicker) {
            // 更新數據結構中相應 cell 的數據
            selectDate = datePicker.date
            
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{
            guard let selectedCell = tableView.cellForRow(at: indexPath) as? ANISelectDateTableViewCell else {return}
            print("\(selectedCell.datePicker.date)")
        }
    }
    
}
