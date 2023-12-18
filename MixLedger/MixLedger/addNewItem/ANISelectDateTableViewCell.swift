//
//  ANISelectDateTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/18.
//

import UIKit

class ANISelectDateTableViewCell: AddNewItemModelTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
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
    

    func setupCell() {
        backgroundColor = .clear
        setupHiden(datePickerHidden: false)
        iconImageView.image = AllIcons.date.icon
    }
}
