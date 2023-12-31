//
//  ShowCustomAlertManager.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/11.
//

import Foundation
import UIKit

class ShowCustomAlertManager {
    static let shared = ShowCustomAlertManager()
    /// 提示框
    /// - Parameters:
    ///   - title: 提示框標題
    ///   - message: 提示訊息
    ///   - vc: 要在哪一個 UIViewController 上呈現
    ///   - actionHandler: 按下按鈕後要執行的動作，沒有的話，就填 nil
    static func customAlert(title: String, message: String, vc: UIViewController, actionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "確認", style: .default) { _ in
            actionHandler?()
        }

        alertController.addAction(closeAction)
        vc.present(alertController, animated: true)
    }

    static func customAlertYesAndNo(title: String, message: String, vc: UIViewController, actionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "確認", style: .default) { _ in
            actionHandler?()
        }
        // 取消按鈕
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
            // 取消按鈕的操作
            // 如果不需要特別處理，可以不提供這個 handler
        }
        alertController.addAction(cancelAction)
        alertController.addAction(closeAction)
        vc.present(alertController, animated: true)
    }
}
