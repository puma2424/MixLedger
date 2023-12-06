//
//  ANISelectDateTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/18.
//

import SnapKit
import UIKit

class ANISelectDateTableViewCell: AddNewItemModelTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupLayout()
        inputText.isHidden = true
        setupDatePicker()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    let datePicker = UIDatePicker()

    override func setupLayout() {
        super.setupLayout()
        contentView.addSubview(datePicker)

        datePicker.snp.makeConstraints { mark in
            mark.height.equalTo(contentView)
            mark.width.equalTo(contentView.bounds.size.width * 0.8)
            mark.centerY.equalTo(contentView)
            mark.trailing.equalTo(contentView.snp.trailing).offset(-12)
        }
    }

    func setupDatePicker() {
        datePicker.datePickerMode = .date
        let currentDate = Date()
//        let twoYearsFromNow = Calendar.current.date(byAdding: .year, value: 2, to: currentDate)
//
//        datePicker.minimumDate = currentDate
//        datePicker.maximumDate = twoYearsFromNow
        datePicker.setDate(currentDate, animated: true)
    }
}
