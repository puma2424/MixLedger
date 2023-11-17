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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
    func setTable(){
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.register(MoneyTableViewCell.self, forCellReuseIdentifier: "moneyCell")
    }
    
    func setLayout(){
        view.addSubview(table)
        view.addSubview(lineView)
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
        
        table.snp.makeConstraints{(mark) in
            mark.top.equalTo(lineView.snp.bottom)
            mark.leading.equalTo(view)
            mark.bottom.equalTo(view)
            mark.trailing.equalTo(view)
        }
        
    }
    

}

extension AddNewItemViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moneyCell", for: indexPath)
        guard let monryCell = cell as? MoneyTableViewCell else { return cell }
        monryCell.iconImageView.image = UIImage(named: AllIcons.more.rawValue)
        return monryCell
    }
    
    
}
