//
//  SelectUserIconViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/17.
//

import UIKit

class SelectUserIconViewController: SelectIconViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        delegate = self
        iconGroup = SelectIconManager().userIconGroup
        iconCollectionView.reloadData()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

//extension SelectUserIconViewController: SelectIconViewControllerDelegate {
//    func setupIconGroup(selectionIconView: SelectIconViewController, selectIconManager: SelectIconManager) {
//        self.iconGroup = selectIconManager.userIconGroup
//        iconCollectionView.reloadData()
//    }
//}
