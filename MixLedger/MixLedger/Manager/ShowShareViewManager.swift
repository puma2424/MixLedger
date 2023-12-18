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

    static func showShare(content: [Any], vc: UIViewController) {
        let ac = UIActivityViewController(activityItems: content, applicationActivities: nil)
        vc.present(ac, animated: true, completion: nil)
    }
}
