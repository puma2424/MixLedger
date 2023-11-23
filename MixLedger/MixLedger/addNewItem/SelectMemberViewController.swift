//
//  SelectPayingMemberViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/23.
//

import UIKit

class SelectMemberViewController: UIViewController{
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTable()
        setupLayout()
//        self.title = "選擇成員"
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
//        tableView.delegate = self
//        tableView.dataSource = self
        
    }
    
    func setupLayout(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{(mark) in
            mark.top.equalTo(view.safeAreaLayoutGuide)
            mark.leading.equalTo(view.safeAreaLayoutGuide)
            mark.trailing.equalTo(view.safeAreaLayoutGuide)
            mark.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

//extension SelectMemberViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        3
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//    }
//}
