//
//  ANITypeTableViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import UIKit

class ANITypeTableViewCell: AddNewItemModelTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        self.setupHiden(titleLabelHidden: false)
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

    func setupCell(){
        titleLabel.text = "請選擇類別"
        iconImageView.image = UIImage(named: AllIcons.foodRice.rawValue)
    }
}
