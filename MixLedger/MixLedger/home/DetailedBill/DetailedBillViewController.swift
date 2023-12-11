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
    
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        return table
    }()
    
    func setupTable(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(DetailedBillTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func setupLayout(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view)
        }
    }

}

extension DetailedBillViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
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
                detailCell.iconImageView.image = AllIcons.date.icon
                detailCell.contentLabel.text = "\(data.date)"
            case 5:
                detailCell.iconImageView.image = AllIcons.moneyAndCoin.icon
                detailCell.contentLabel.text = "\(data.amount)"
            default:
                break
            }
//            detailCell.iconImageView.image = AllIcons.moneyAndCoin.icon
//            detailCell.contentLabel.text = "\(data.amount)"
        
            
        return cell
    }
    
    
}
