//
//  SharedBillStatusOpenView.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/16.
//

import UIKit
import SnapKit
protocol SharedBillStatusOpenViewDelegate{
    func closeView()
}

class SharedBillStatusOpenView: SharedBillStatusSmallView{
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setpuLayout()
//        adjustDate(by: 0)
        self.backgroundColor = .white
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
    var users: [UsersInfo]? = nil
    var openDelegate: SharedBillStatusOpenViewDelegate?
    let table = UITableView()
    
    func setupTable(){
        table.delegate = self
        table.dataSource = self
        table.register(SBSVUsersTableViewCell.self, forCellReuseIdentifier: "userCell")
    }
    
    override func setpuLayout() {
        super.setpuLayout()
        addSubview(table)
        table.snp.makeConstraints{(mark) in
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        guard let userCell = cell as? SBSVUsersTableViewCell else { return cell }
        return userCell
    }
}
