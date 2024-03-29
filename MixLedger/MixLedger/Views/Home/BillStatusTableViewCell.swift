//
//  BillStatusTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import SnapKit
import UIKit
protocol BillStatusTableViewCellDelegate: AnyObject {
    func changeMonth(cell: BillStatusTableViewCell, date: Date)
}

class BillStatusTableViewCell: UITableViewCell {
    // 初始化方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    // 如果是使用 Interface Builder，這個初始化方法會被呼叫
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // 共用的初始化邏輯
    private func commonInit() {
        // 在這裡放置需要在初始化時執行的程式碼
        setupLayout()
        setButtonTarge()
        adjustDate(by: 0)
        backgroundColor = .g3()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 在 tableView 的父视图中设置阴影
        superview?.layer.shadowColor = UIColor.g2().cgColor
        superview?.layer.shadowOffset = CGSize(width: 0, height: 5)
        superview?.layer.shadowRadius = 4
        superview?.layer.shadowOpacity = 1.0
        superview?.layer.masksToBounds = false
    }

    var delegate: BillStatusTableViewCellDelegate?

    let lastMonthButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(systemName: "triangle.fill") {
            let rotatedImage = image.rotate(radians: -.pi / 2)
            button.setImage(rotatedImage, for: .normal)
        }
        return button
    }()

    let monthLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let nextMonthButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(systemName: "triangle.fill") {
            let rotatedImage = image.rotate(radians: .pi / 2)
            button.setImage(rotatedImage, for: .normal)
        }
        return button
    }()

    let totalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "總額"
        label.textColor = .g1()
        label.sizeToFit()
        return label
    }()

    let totalMoneyLabel: UILabel = {
        let label = UILabel()
        label.text = "NT$ 3000"
        label.sizeToFit()
        return label
    }()

    let payTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "支出"
        label.textColor = .g1()
        label.sizeToFit()
        return label
    }()

    let payMoneyLabel: UILabel = {
        let label = UILabel()
        label.text = "NT$ 3000"
        label.sizeToFit()
        return label
    }()

    let revenueTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "收入"
        label.textColor = .g1()
        label.sizeToFit()
        return label
    }()

    let revenueMoneyLabel: UILabel = {
        let label = UILabel()
        label.text = "NT$ 3000"
        label.sizeToFit()
        return label
    }()

    let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.alignment = .fill // 確保子視圖填滿水平空間
        stackView.spacing = 5 // 設置子視圖之間的間距
        return stackView
    }()

    let payStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.alignment = .fill // 確保子視圖填滿水平空間
        stackView.spacing = 5 // 設置子視圖之間的間距
        return stackView
    }()

    let revenueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.alignment = .fill // 確保子視圖填滿水平空間
        stackView.spacing = 5 // 設置子視圖之間的間距
        return stackView
    }()

    let moneyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill // 確保子視圖填滿水平空間
        stackView.spacing = 10 // 設置子視圖之間的間距
        return stackView
    }()

    let openOrCloseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "triangle.fill"), for: .normal)
        if let image = UIImage(systemName: "triangle.fill") {
            let rotatedImage = image.rotate(radians: -.pi)
            button.setImage(rotatedImage, for: .normal)
        }
        return button
    }()

    let dateFont = DateFormatter()
    var showDate: Date = .init()
    var dateString: String = ""
    func setButtonTarge() {
        nextMonthButton.addTarget(self, action: #selector(nextMonthActive), for: .touchUpInside)
        lastMonthButton.addTarget(self, action: #selector(lastMonthActive), for: .touchUpInside)
        openOrCloseButton.addTarget(self, action: #selector(openOrCloseActive), for: .touchUpInside)
    }

    @objc func nextMonthActive() {
        adjustDate(by: 1)
    }

    @objc func lastMonthActive() {
        adjustDate(by: -1)
    }

    @objc func openOrCloseActive() {}

    func adjustDate(by months: Int) {
        dateFont.dateFormat = "yyyy-MM"

        if let newDate = Calendar.current.date(byAdding: .month, value: months, to: showDate) {
            showDate = newDate
            dateString = dateFont.string(from: newDate)
            monthLabel.text = dateString
            delegate?.changeMonth(cell: self, date: newDate)
        }
    }

    func setupLayout() {
        addToView(superV: contentView, subs: lastMonthButton, monthLabel, nextMonthButton, moneyStackView)
        totalStackView.addArrangedSubview(totalMoneyLabel)
        totalStackView.addArrangedSubview(totalTitleLabel)
        payStackView.addArrangedSubview(payMoneyLabel)
        payStackView.addArrangedSubview(payTitleLabel)
        revenueStackView.addArrangedSubview(revenueMoneyLabel)
        revenueStackView.addArrangedSubview(revenueTitleLabel)
        moneyStackView.addArrangedSubview(totalStackView)
        moneyStackView.addArrangedSubview(payStackView)
        moneyStackView.addArrangedSubview(revenueStackView)

        lastMonthButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.leading.equalTo(contentView).offset(16)
            make.top.equalTo(contentView).offset(16)
        }

        monthLabel.snp.makeConstraints { make in
            make.leading.equalTo(lastMonthButton.snp.trailing).offset(8)
            make.centerY.equalTo(lastMonthButton)
        }

        nextMonthButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.leading.equalTo(monthLabel.snp.trailing).offset(8)
            make.centerY.equalTo(lastMonthButton)
        }
        moneyStackView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.top.equalTo(monthLabel.snp.bottom).offset(16)
            make.bottom.equalTo(contentView).offset(-16)
        }
    }

    func addToView(superV: UIView, subs: UIView...) {
        subs.forEach {
            superV.addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
