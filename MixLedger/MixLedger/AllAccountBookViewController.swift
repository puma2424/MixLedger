//
//  AllAccountBookViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import UIKit

class AllAccountBookViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setNavigation(){
        // 導覽列左邊按鈕
        let editAccountBookButton = UIBarButtonItem(
            image: UIImage(named:"storytelling")?.withRenderingMode(.alwaysOriginal),
          style:.plain ,
          target:self ,
          action: #selector(editAccountBook))
        // 加到導覽列中
        self.navigationItem.leftBarButtonItem = editAccountBookButton

        // 導覽列右邊按鈕
        let shareButton = UIBarButtonItem(
//          title:"設定",
            image: UIImage(named:"share")?.withRenderingMode(.alwaysOriginal),
          style:.plain,
          target:self,
          action:#selector(shareAccountBook))
        // 加到導覽列中
        self.navigationItem.rightBarButtonItem = shareButton
    }
}
