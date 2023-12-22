//
//  UIViewController+EXT.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/22.
//

import Foundation
import UIKit

extension UIViewController {
    func showShare(content: [Any]) {
        let activityVC = UIActivityViewController(activityItems: content, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
}
