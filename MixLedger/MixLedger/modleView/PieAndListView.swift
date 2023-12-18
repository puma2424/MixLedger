//
//  PieAndListView.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/12.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let value: Double
}

struct PieAndListView: View {
    @Binding var data: [Double]
    @Binding var labels: [String]
    @Binding var iconName: [String]

    @State private var dataList: [Item] = [Item(icon: "", label: "", value: 0.0)]
    private let colors: [Color]
    private let borderColor: Color
    private let sliceOffset: Double = -.pi / 2
    @State private var total: Double = 0.0
    @State private var currentColor: Color = .g1

    init(data: Binding<[Double]>,
         labels: Binding<[String]>,
         iconName: Binding<[String]>,
         colors: [Color],
         borderColor: Color)
    {
        _data = data
        _labels = labels
        _iconName = iconName
        self.colors = colors
        self.borderColor = borderColor
    }

    private func setDataList() {
        dataList.removeAll()
        for indxe in 0 ..< data.count {
            let iconName = iconName[indxe] as? String ?? ""
            let subType = labels[indxe] as? String ?? ""
            let value = data[indxe] as? Double ?? 0.0
            dataList.append(Item(icon: iconName, label: subType, value: value))
            total += value
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                Color.g3
                VStack {
                    // 使用自定義的 View
                    PieChart(data: .constant(data),
                             labels: .constant(labels),
                             colors: colors,
                             borderColor: .brightGreen1)
                        .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.4) // 調整 PieChart 的寬高
                        .padding(.bottom, 10) // 調整 PieChart 與 Divider 之間的距離
                        .padding(.top, 20)
                    // 添加一個分隔線
//                        Divider()

                    // 在下半部放置 List
                    List(Array(dataList.enumerated()), id: \.element.id) { index, item in
                        HStack(spacing: 12) {
                            Image(item.icon)
                                .resizable()
                                .frame(width: 40, height: 40)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.label)
                                    .font(.headline)
                                    .foregroundColor(.g1) // 設置文字顏色
                                Text("Total:" + String(format: "%.2f", item.value))
                                    .font(.subheadline)
                                    .foregroundColor(.gray) // 設置文字顏色
                            }

                            Spacer() // 添加 Spacer 使標籤和金錢標籤靠近右側
                            Text(String(format: "%.2f", item.value / total * 100) + "%")
                                .padding(.trailing, 10)
                                .bold()
                                .font(.system(size: 20))
                                .foregroundColor(colors[index % colors.count]) // 設置文字顏色
                                .shadow(color: .gray, radius: 1, x: 2, y: 2)
                        }
                        .listRowBackground(Color.g3)
                    }
                    .listStyle(.plain) // 設置List的樣式
                    .padding(.horizontal, 16)
                    .background(Color.g3)

                    Spacer()
                }
                .background(Color.g3)
            }
            .onAppear {
                setDataList()
            }
        }
    }
}
