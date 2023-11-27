//
//  ChartsViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/27.
//

import UIKit
import SnapKit

class ChartsViewController: UIViewController, SegmentedControlModleViewDelegate {
    func change(to index: Int) {
        return
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "圖表分析"
        setupSegmentedControl()
        setupLayout()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    let segmentedView = SegmentedControlModleView()
    
    func setupSegmentedControl(){
        segmentedView.delegate = self
        segmentedView.setButtonTitles(buttonTitles: ["圓餅圖", "折線圖"])
    }
    
    func setupLayout(){
        view.addSubview(segmentedView)
        
        segmentedView.snp.makeConstraints{(mark) in
            mark.top.equalTo(view.safeAreaLayoutGuide)
            mark.leading.equalTo(view.safeAreaLayoutGuide)
            mark.trailing.equalTo(view.safeAreaLayoutGuide)
            mark.height.equalTo(50)
        }
        
    }
}
