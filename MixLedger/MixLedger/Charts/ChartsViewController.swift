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
        checkArrayhaveData(index: index)
        currentIndex = index
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

        checkArrayhaveData(index: currentIndex)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    var currentDate: Date = .init()

    var currentMainTypr: TransactionMainType = .expenses

    var currentIndex = 0

    let saveData = SaveData.shared

    var currentChartView: UIView?

    let segmentedView = SegmentedControlModleView()

    var pieChart = PieChart(data: .constant([30, 50, 20]),
                            labels: .constant(["Label1", "Label2", "Label3"]),
                            colors: [.blue1, .blue2, .brightGreen1],
                            borderColor: .gray1)

    var mySwiftUIView = LineMarkCharts()

    let noDataNoteLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "There are no financial records available. \n Add the first entry to your accounts!"
        label.numberOfLines = 0
        label.textColor = .g1()
        return label
    }()

    func checkArrayhaveData(index: Int) {
        currentChartView?.removeFromSuperview()
        currentChartView = nil

        if saveData.transactionsArray.isEmpty {
            currentChartView = setupLabelView()
        } else {
            if index == 0 {
                currentChartView = setupPie()
            } else {
                currentChartView = setupLineMarkView()
            }
        }
    }

    func setupSegmentedControl() {
        segmentedView.delegate = self
        segmentedView.backgroundColor = .clear
        segmentedView.setButtonTitles(buttonTitles: ["本月支出分析", "年度支出趨勢"])
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

    func setupLabelView() -> UIView {
        view.addSubview(noDataNoteLabel)

        noDataNoteLabel.snp.makeConstraints { mark in
            mark.centerX.equalTo(view)
            mark.centerY.equalTo(view)
        }
        return noDataNoteLabel
    }

//    private let stockEntityViewModel = StockEntityViewModel()
    func setupLineMarkView() -> UIView {
        mySwiftUIView.stockData.removeAll()

        // 创建 SwiftUI 视图
//        mySwiftUIView.vm.stockData = saveData.transactionsArray
        mySwiftUIView.stockData = dataToChartArray()

        // 将 SwiftUI 视图包装在 UIHostingController 中
        let hostingController = UIHostingController(rootView: mySwiftUIView)

        hostingController.view.backgroundColor = .clear
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
        let originaldatas = saveData.transactionsArray
        let datas = originaldatas.filter { data in
            let calendar = Calendar.current
            let currentDateMon = calendar.dateComponents([.month], from: currentDate)
            let dataDateMon = calendar.dateComponents([.month], from: data.date)
            return data.amount != 0 && currentDateMon == dataDateMon
        }
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

        let colorArray: [Color] = ColorManager.getAllColors() as [Color]

        pieChart = PieChart(data: .constant(amountArray),
                            labels: .constant(typeArray),
                            colors: colorArray,
                            borderColor: .brightGreen1)

        // Create a UIHostingController to wrap the SwiftUI view
        let hostingController = UIHostingController(rootView: pieChart)

        hostingController.view.backgroundColor = .clear
        // Add the SwiftUI view to the UIKit view hierarchy
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        // Set constraints if needed
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
//            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
//            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.heightAnchor.constraint(equalToConstant: 200),
            hostingController.view.widthAnchor.constraint(equalToConstant: 200),
            hostingController.view.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        return hostingController.view
    }

    func dataToChartArray() -> [TransactionForChart] {
        var originalDataArray = saveData.transactionsArray
        var forLineMarkData: [TransactionForChart] = []

        let dateFont = DateFormatter()
        dateFont.dateFormat = "yyyy"
        let dateYearString = dateFont.string(from: currentDate)

        let calendar = Calendar.current
        dateFont.dateFormat = "yyyy-MM-dd"

        var components = calendar.dateComponents([.year], from: currentDate)

        for originalData in originalDataArray {
            if TransactionMainType(text: originalData.transactionType.name) == currentMainTypr && originalData.year == dateYearString {
                // 获取当前年份和月份
                components = calendar.dateComponents([.year, .month], from: originalData.date)

                // 设置为每个月的第一天
                var firstDayComponents = components
//                firstDayComponents.month = month
                firstDayComponents.day = 15

                // 创建日期对象
                if let firstDayOfMonth = calendar.date(from: firstDayComponents) {
                    if let index = forLineMarkData.firstIndex(where: { $0.date == firstDayOfMonth && $0.subType == originalData.subType.name }) {
                        print("找到了，位置是 \(index)")
                        forLineMarkData[index].amount += abs(originalData.amount)
                    } else {
                        // 创建 TransactionForChart 对象，amount 设置为 0
                        let transaction = TransactionForChart(amount: abs(originalData.amount),
                                                              date: firstDayOfMonth,
                                                              subType: originalData.subType.name,
                                                              mainType: originalData.transactionType.name)

                        // 将对象添加到数组中
                        forLineMarkData.append(transaction)
                    }
                }
            }
        }
        return forLineMarkData
    }
}

struct TransactionForChart: Identifiable {
    let id = UUID()
    var amount: Double
    var date: Date
    var subType: String
    var mainType: String
}
