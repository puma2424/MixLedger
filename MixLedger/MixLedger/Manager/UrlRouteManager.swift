//
//  UrlRouteManager.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/14.
//

import Foundation
import UIKit

// UrlRouteManager 类
class UrlRouteManager {
    // 弱引用根视图控制器
    weak var rootViewController: UIViewController?

    // 单例模式，共享的实例
    static var shared = UrlRouteManager()

    // 应用程序名称
    let appName = "MixLedger"

    // 枚举定义不同的终端点（EndPoint）
    enum EndPoint: String {
        case account
        case user
    }

    // MARK: 读取和创建URL

    // 检查是否能打开给定的URL
    func canOpen(url: URL) -> Bool {
        let components = url.pathComponents
        guard let endpoint = url.host(),
              EndPoint(rawValue: endpoint) != nil
        else {
            print(url.host())
            return false
        }
        return true
    }

    // 打开给定的URL
    static func open(url: URL) {
        print("open url")
        let components = url.pathComponents
        guard let host = url.host(),
              let endpoint = EndPoint(rawValue: host) else { return }

        // 根据不同的终端点执行相应的操作
        switch endpoint {
        case .account:
            shared.joinAccount(components)
            print("open Account")
        case .user:
            print("open User")
        }
    }

    // 创建URL字符串
    static func createUrlString(
        for endPoint: EndPoint,
        components: [String]
    ) -> String {
        shared.appName + "://" + endPoint.rawValue +
            "/" + components.joined(separator: "/")
    }

    // MARK: - Meeting

    private func joinAccount(_ urlPathComponents: [String]) {
        guard urlPathComponents.count == 2 else { return }
        print("==================")
        print(urlPathComponents)
        print(urlPathComponents.count)
        print("==================")

        let accountID = urlPathComponents[1]

        if let myAccoumt = SaveData.shared.myInfo?.shareAccount.filter({ $0 == accountID }),
           myAccoumt.count == 0
        {
            if let window = SceneDelegate.shared.window,
               let rootViewController = window.rootViewController
            {
                ShowCustomAlertManager.customAlertYesAndNo(title: "邀請你加入共享帳本",
                                                           message: "請問要加入共享帳本嗎？",
                                                           vc: rootViewController)
                {
                    FirebaseManager.shared.postRespondToInvitation(respond: true, accountID: accountID, accountName: "", inviterID: "", inviterName: "") { result in
                        switch result {
                        case let .success(success):
                            LKProgressHUD.showSuccess(text: success)
                        case .failure:
                            LKProgressHUD.showFailure()
                        }
                    }
                }
            }
        } else {
            if let window = SceneDelegate.shared.window,
               let rootViewController = window.rootViewController
            {
                ShowCustomAlertManager.customAlert(title: "已加入共享帳本", message: "你已在共享帳本中", vc: rootViewController, actionHandler: nil)
            }
        }
    }
}
