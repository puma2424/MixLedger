//
//  ViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/14.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "我的帳本"
        setuupLayout()
        
        
    }

    let billStatus = SharedBillStatusSmallView()
    
    func setuupLayout(){
        billStatus.layer.cornerRadius = 10
        view.addSubview(billStatus)
        billStatus.snp.makeConstraints{(make) in
            make.width.equalTo(view.bounds.size.width * 0.9)
            make.height.equalTo(110)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            print("\(billStatus.bounds.size)")
        }
        
    }
    

}

