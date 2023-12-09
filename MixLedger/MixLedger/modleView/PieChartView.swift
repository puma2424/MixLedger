//
//  PieChartView.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/28.
//

import SwiftUI

struct PieChartView: View {
    let title: String
    let description: String

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Text(description)
                .font(.body)
        }
    }
}

#Preview {
    PieChartView(title: "hi", description: "")
}

struct PieChart: View {
    @Binding var data: [Double]
    @Binding var labels: [String]

    private let colors: [Color]
    private let borderColor: Color
    private let sliceOffset: Double = -.pi / 2
    @State private var total: Double = 0.0
    
    init(data: Binding<[Double]>, labels: Binding<[String]>, colors: [Color], borderColor: Color) {
        _data = data
        _labels = labels
        self.colors = colors
        self.borderColor = borderColor
    }

    var body: some View {
        
        GeometryReader { geo in
            ZStack(alignment: .center) {
                
                ForEach(0 ..< data.count) { index in
                    PieSlice(startAngle: startAngle(for: index), endAngle: endAngle(for: index))
                        .fill(colors[index % colors.count])

                    PieSlice(startAngle: startAngle(for: index), endAngle: endAngle(for: index))
                        .stroke(Color.white, lineWidth: 1)

                    PieChartView(
                        title: "\(labels[index])",
                        description: String(format: "%.2f%%", data[index] / total * 100)
                    )
                    .offset(textOffset(for: index, in: geo.size))
                    .zIndex(1)
                    .onAppear { 
                        sum() // 在視圖出現時計算 total
                    }
                }
            }
        }
    }
    
    private func sum() {
            total = data.reduce(0.0, +)
        }

    private func startAngle(for index: Int) -> Double {
        switch index {
        case 0:
            return sliceOffset
        default:
            let ratio: Double = data[..<index].reduce(0.0, +) / data.reduce(0.0, +)
            return sliceOffset + 2 * .pi * ratio
        }
    }

    private func endAngle(for index: Int) -> Double {
        switch index {
        case data.count - 1:
            return sliceOffset + 2 * .pi
        default:
            let ratio: Double = data[..<(index + 1)].reduce(0.0, +) / data.reduce(0.0, +)
            return sliceOffset + 2 * .pi * ratio
        }
    }

    private func textOffset(for index: Int, in size: CGSize) -> CGSize {
        let radius = min(size.width, size.height) / 3
        let dataRatio = (2 * data[..<index].reduce(0, +) + data[index]) / (2 * data.reduce(0, +))
        let angle = CGFloat(sliceOffset + 2 * .pi * dataRatio)
        return CGSize(width: radius * cos(angle), height: radius * sin(angle))
    }
}

struct PieSlice: Shape {
    let startAngle: Double
    let endAngle: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(rect.width, rect.height) / 2
        let alpha = CGFloat(startAngle)

        let center = CGPoint(
            x: rect.midX,
            y: rect.midY
        )

        path.move(to: center)

        path.addLine(
            to: CGPoint(
                x: center.x + cos(alpha) * radius,
                y: center.y + sin(alpha) * radius
            )
        )

        path.addArc(
            center: center,
            radius: radius,
            startAngle: Angle(radians: startAngle),
            endAngle: Angle(radians: endAngle),
            clockwise: false
        )

        path.closeSubpath()

        return path
    }
}
