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
        guard let first = components.first,
              EndPoint(rawValue: first) != nil
        else {
            return false
        }
        return true
    }

    // 打开给定的URL
    func open(url: URL) {
        print("open url")
        let components = url.pathComponents
        guard let host = url.host(),
              let endpoint = EndPoint(rawValue: host) else { return }

        // 根据不同的终端点执行相应的操作
        switch endpoint {
        case .account:
            joinAccount(components)
            print("open Account")
        case .user:
            print("open User")
        }
    }

    // 创建URL字符串
    func createUrlString(
        for endPoint: EndPoint,
        components: [String]
    ) -> String {
        appName + "://" + endPoint.rawValue +
                    "/" + components.joined(separator: "/")
    }

    // MARK: - Meeting
    // 处理与会议相关的操作
    func joinAccount(_ urlPathComponents: [String]) {
        // 确保根视图控制器是 FSTabBarController，并且 URL 路径组件数量为2
        guard urlPathComponents.count == 2
        else { return }
        print("==================")
        print(urlPathComponents)
        print(urlPathComponents.count)
        print("==================")
        if let window = SceneDelegate.shared.window,
           let rootViewController = window.rootViewController
        {
            ShowCustomAlertManager.customAlert(title: "邀請你加入共享帳本", message: "請問要加入共享帳本嗎？", vc: rootViewController) {
                return
            }
        }
        
    }
}
