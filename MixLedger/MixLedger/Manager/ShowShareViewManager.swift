//
//  ShowShareViewManager.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/14.
//

import Foundation
import UIKit

class ShowShareViewManager {
    static let shared = ShowShareViewManager()

    static func showShare(content: [Any], viewController: UIViewController) {
        let activityVC = UIActivityViewController(activityItems: content, applicationActivities: nil)
        viewController.present(activityVC, animated: true, completion: nil)
    }
}
