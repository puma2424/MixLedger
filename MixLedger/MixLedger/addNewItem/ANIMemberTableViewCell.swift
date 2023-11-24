//
//  ANIMemberTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import UIKit
import SnapKit

class ANIMemberTableViewCell: UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTable()
        setupLayout()
//        memberInfo()
    }
    
    required init?(coder: NSCoder) {
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
    
    var usersMoney: [String: Double]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    let saveData = SaveData.shared
    
    let showTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    
    let tableView = UITableView()
    
    func setupTable(){
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ShowMemberTableViewCell.self, forCellReuseIdentifier: "cell")
    
    }
    
    func setupLayout(){
        addSubview(showTitleLabel)
        addSubview(tableView)
        
//        showTitleLabel.snp.makeConstraints{(make) in
//            make.top.equalTo(self).offset(12)
//            make.centerX.equalTo(self)
//        }
//        tableView.tableHeaderView = showTitleLabel
        
        showTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(12)
            make.centerX.equalTo(self)
            
        }
        
        tableView.snp.makeConstraints{(mark) in
            mark.top.equalTo(showTitleLabel.snp.bottom)
            mark.leading.equalTo(self)
            mark.bottom.equalTo(self)
            mark.trailing.equalTo(self)
            mark.height.equalTo(100)
        }
    }
    
    
}

extension ANIMemberTableViewCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usersMoney?.keys.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let searchCell = cell as? ShowMemberTableViewCell else { return cell }
        guard let usersMoney = usersMoney else { return cell }
        var userID: [String] = []
        for key in usersMoney.keys{
            userID.append(key)
        }
        searchCell.nameLabel.text = saveData.userInfoData[userID[indexPath.row]]?.name
        if let money = usersMoney[userID[indexPath.row]]{
            searchCell.moneyLabel.text = "\(money)"
        }
        
        
        return searchCell
    }
    
    
}
