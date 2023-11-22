//
//  IconCollectionViewCell.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/21.
//

import UIKit
import SnapKit

class ANAIconCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let colorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        
        contentView.addSubview(colorView)
        colorView.addSubview(imageView)
        colorView.snp.makeConstraints{(mark) in
            mark.centerX.equalTo(contentView)
            mark.centerY.equalTo(contentView)
            mark.width.height.equalTo(55)
        }
        
        imageView.snp.makeConstraints{(mark) in
            mark.centerX.equalTo(colorView)
            mark.centerY.equalTo(colorView)
            mark.width.height.equalTo(45)
        }
    }
    
    func setupColorView(){
        colorView.backgroundColor = .white
        colorView.layer.cornerRadius = 10
    }
}
