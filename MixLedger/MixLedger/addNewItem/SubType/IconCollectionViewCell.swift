//
//  IconCollectionViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/8.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    let selectedViewColor: UIColor = .init(red: 190 / 255, green: 239 / 255, blue: 218 / 255, alpha: 0.5)

    let selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 30
        return view
    }()

    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.g1()
        return label
    }()

    // 使用 UIStackView 垂直排列 label 和 imageView
    var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        view.alignment = .center
        view.distribution = .fill
        return view
    }()

    func didSeiected(selected: Bool) {
        if selected {
            selectedView.backgroundColor = selectedViewColor
        } else {
            selectedView.backgroundColor = .clear
        }
    }

    func layoutCell(image: UIImage?, text: String) {
        iconImageView.image = image
        titleLabel.text = text
    }

    func setupLayout() {
        contentView.addSubview(selectedView)
        contentView.addSubview(stackView)
        stackView.addSubview(iconImageView)
        stackView.addSubview(titleLabel)

        selectedView.snp.makeConstraints { mark in
            mark.centerX.equalTo(contentView)
            mark.centerY.equalTo(contentView)
            mark.width.equalTo(60)
            mark.height.equalTo(60)
        }

        iconImageView.snp.makeConstraints { mark in
            mark.centerX.equalTo(stackView)
            mark.top.equalTo(stackView).offset(8)
            mark.width.height.equalTo(45)
        }

        titleLabel.snp.makeConstraints { mark in
            mark.centerX.equalTo(stackView)
            mark.trailing.equalTo(stackView)
            mark.top.equalTo(iconImageView.snp.bottom).offset(4)
        }

        stackView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
        }
    }
}
