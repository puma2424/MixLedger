//
//  MessageViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/22.
//

import UIKit
import SnapKit
class MessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
        setupTable()
        self.navigationItem.title = "通知"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    let tableView = UITableView()
    
    func setupTable(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(InviteMessageTableViewCell.self, forCellReuseIdentifier: "inviteCell")
    }
    
    func setupLayout(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{(mark) in
            mark.leading.equalTo(view.safeAreaLayoutGuide)
            mark.top.equalTo(view.safeAreaLayoutGuide)
            mark.trailing.equalTo(view.safeAreaLayoutGuide)
            mark.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }

}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell", for: indexPath)
        guard let inviteCell = cell as? InviteMessageTableViewCell else { return cell }
        
        return inviteCell
    }
    
    
}
