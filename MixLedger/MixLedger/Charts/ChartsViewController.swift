//
//  ChartsViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/27.
//

import SnapKit
import SwiftUI
import UIKit

class ChartsViewController: UIViewController, SegmentedControlModleViewDelegate {
    func change(to index: Int) {
        // Remove the current chart view
        currentChartView?.removeFromSuperview()

        // Add the new chart view based on the selected index
        if index == 0 {
            currentChartView = setupPie()
        } else {
            currentChartView = setupLineMarkView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "圖表分析"
        setupSegmentedControl()
        setupLayout()

        currentChartView = setupPie()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentChartView = setupPie()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    let saveData = SaveData.shared

    var currentChartView: UIView?

    let segmentedView = SegmentedControlModleView()

    var pieChart = PieChart(data: .constant([30, 50, 20]),
                            labels: .constant(["Label1", "Label2", "Label3"]),
                            colors: [.red, .green, .blue],
                            borderColor: .white)

    let mySwiftUIView = LineMarkCharts()

    func setupSegmentedControl() {
        segmentedView.delegate = self
        segmentedView.setButtonTitles(buttonTitles: ["圓餅圖", "折線圖"])
    }

    func setupLayout() {
        view.addSubview(segmentedView)

        segmentedView.snp.makeConstraints { mark in
            mark.top.equalTo(view.safeAreaLayoutGuide)
            mark.leading.equalTo(view.safeAreaLayoutGuide)
            mark.trailing.equalTo(view.safeAreaLayoutGuide)
            mark.height.equalTo(50)
        }
    }

//    private let stockEntityViewModel = StockEntityViewModel()
    func setupLineMarkView() -> UIView {
        // 创建 SwiftUI 视图
        mySwiftUIView.vm.stockData = saveData.transactionsArray

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
            hostingController.view.heightAnchor.constraint(equalToConstant: 400),
        ])
        return hostingController.view
    }

    func setupPie() -> UIView {
        let datas = saveData.transactionsArray
        var dic: [String: Double] = [:]
        for data in datas {
            if dic[data.subType.name] == nil {
                dic[data.subType.name] = data.amount
            } else {
                dic[data.subType.name]? += data.amount
            }
        }

        var amountArray: [Double] = []
        var typeArray: [String] = []

        for type in dic.keys {
            typeArray.append(type)
            amountArray.append(dic[type] ?? 0.0)
        }

        pieChart = PieChart(data: .constant(amountArray),
                            labels: .constant(typeArray),
                            colors: [.red, .green, .blue],
                            borderColor: .white)

        // Create a UIHostingController to wrap the SwiftUI view
        let hostingController = UIHostingController(rootView: pieChart)

        // Add the SwiftUI view to the UIKit view hierarchy
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        // Set constraints if needed
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.heightAnchor.constraint(equalToConstant: 400),
        ])
        return hostingController.view
    }
}
