//
//  BillStatusTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import SnapKit
import UIKit
protocol BillStatusTableViewCellDelegate {
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
//        layer.shadowColor = UIColor.clear.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2)
//        layer.shadowRadius = 4
//        layer.shadowOpacity = 0.8
//        layer.masksToBounds = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        label.sizeToFit()
        return label
    }()

    let revenueMoneyLabel: UILabel = {
        let label = UILabel()
        label.text = "NT$ 3000"
        // 設置 UILabel 的大小

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
    var showDate: Date = Date()
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
//        addToView(superV: self, subs: lastMonthButton, monthLabel, nextMonthButton, totalMoneyLabel,totalTitleLabel, payMoneyLabel, payTitleLabel, revenueMoneyLabel, revenueTitleLabel)
//        addToView(superV: contentView, subs: openOrCloseButton)
        totalStackView.addArrangedSubview(totalMoneyLabel)
        totalStackView.addArrangedSubview(totalTitleLabel)
        payStackView.addArrangedSubview(payMoneyLabel)
        payStackView.addArrangedSubview(payTitleLabel)
        revenueStackView.addArrangedSubview(revenueMoneyLabel)
        revenueStackView.addArrangedSubview(revenueTitleLabel)
        moneyStackView.addArrangedSubview(totalStackView)
        moneyStackView.addArrangedSubview(payStackView)
        moneyStackView.addArrangedSubview(revenueStackView)
//        addToView(superV: totalStackView, subs: totalMoneyLabel, totalTitleLabel)
//        addToView(superV: payStackView, subs:  payMoneyLabel, payTitleLabel)
//        addToView(superV: revenueStackView, subs: revenueMoneyLabel, revenueTitleLabel)
//        addToView(superV: moneyStackView, subs: totalStackView,payStackView,revenueStackView)
//        addToView(superV: self, subs: moneyStackView)
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

//        totalMoneyLabel.snp.makeConstraints{(make) -> Void in
        ////            make.centerX.equalTo(self).offset(self.bounds.width/4)
//            make.leading.equalTo(self).offset(16)
//            make.top.equalTo(lastMonthButton.snp.bottom).offset(8)
//        }
//
//        totalTitleLabel.snp.makeConstraints{(make) -> Void in
//            make.centerX.equalTo(totalMoneyLabel)
//            make.top.equalTo(totalMoneyLabel.snp.bottom).offset(8)
//        }
//
//        payMoneyLabel.snp.makeConstraints{(make) -> Void in
//            make.centerX.equalTo(self)
//            make.top.equalTo(lastMonthButton.snp.bottom).offset(8)
//        }
//
//        payTitleLabel.snp.makeConstraints{(make) -> Void in
//            make.centerX.equalTo(payMoneyLabel)
//            make.top.equalTo(payMoneyLabel.snp.bottom).offset(8)
//        }
//
//        revenueMoneyLabel.snp.makeConstraints{(make) -> Void in
        ////            make.centerX.equalTo(self.snp_centerXWithinMargins).offset(self.frame.width/4)
//            make.trailing.equalTo(self.snp.trailing).offset(-16)
//            make.top.equalTo(lastMonthButton.snp.bottom).offset(8)
//        }
//
//        revenueTitleLabel.snp.makeConstraints{(make) -> Void in
//            make.centerX.equalTo(revenueMoneyLabel)
//            make.top.equalTo(revenueMoneyLabel.snp.bottom).offset(8)
//        }
    }

    func addToView(superV: UIView, subs: UIView...) {
        subs.forEach {
            superV.addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
