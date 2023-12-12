//
//  SharedBillStatusSmallView.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/16.
//

import SnapKit
import UIKit
protocol SharedBillStatusSmallViewDelegate {
    func openView()
}

class SharedBillStatusSmallView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setpuLayout()
        backgroundColor = .white
        print("\(self.frame.size)－－－－－－－－")
        setButtonTarge()
        backgroundColor = .brightGreen4()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

    var smallDelegate: SharedBillStatusSmallViewDelegate?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "帳款狀態"
        return label
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

    func setButtonTarge() {
        openOrCloseButton.addTarget(self, action: #selector(openOrCloseActive), for: .touchUpInside)
    }

    @objc func openOrCloseActive() {
        smallDelegate?.openView()
    }

    func setpuLayout() {
        print("-\(frame.size)-")

        addToView(superV: self, subs: openOrCloseButton, titleLabel)
//
        openOrCloseButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.bottom.equalTo(self).offset(-8)
            make.trailing.equalTo(self).offset(-8)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
    }

    func addToView(superV: UIView, subs: UIView...) {
        subs.forEach {
            superV.addSubview($0)
        }
    }
}
