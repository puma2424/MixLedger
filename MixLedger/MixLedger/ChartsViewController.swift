//
//  ChartsViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/27.
//

import UIKit
import SnapKit
import SwiftUI

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
        // 创建 SwiftUI 视图
        let mySwiftUIView = LineMarkCharts()
        
        // 将 SwiftUI 视图包装在 UIHostingController 中
        let hostingController = UIHostingController(rootView: mySwiftUIView)
        
        // 将 hosting controller 的视图添加到你的视图层次结构中
        addChild(hostingController)
        view.addSubview(hostingController.view)
        // 通知 hosting controller 已添加到父视图控制器
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.heightAnchor.constraint(equalToConstant: 400)
        ])
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
