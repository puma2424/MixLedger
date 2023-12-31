//
//  ShowScreenManager.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/5.
//

import Foundation
import UIKit

class ShowScreenManager {
    static let shared = ShowScreenManager()

    static func showMainScreen(window: UIWindow) {
        window.rootViewController?.removeFromParent()
        let tabbar = UITabBarController()
        tabbar.tabBar.backgroundColor = UIColor.clear
        let firstVC = UINavigationController(rootViewController: HomeViewController())
        let secondVC = UINavigationController(rootViewController: MessageViewController())
        let chartsVC = UINavigationController(rootViewController: ChartsViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())

        firstVC.tabBarItem.title = "Home"
        secondVC.tabBarItem.title = "Messages"
        chartsVC.tabBarItem.title = "Charts"
        profileVC.tabBarItem.title = "Profile"

        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.brightGreen3()], for: .selected)

        firstVC.tabBarItem.image = UIImage(named: "bookAndPencil")?.withRenderingMode(.alwaysOriginal)
        secondVC.tabBarItem.image = AllIcons.wallet.icon?.withRenderingMode(.alwaysOriginal)
        chartsVC.tabBarItem.image = AllIcons.icons8Chart.icon?.withRenderingMode(.alwaysOriginal)
        profileVC.tabBarItem.image = AllIcons.settingsMale.icon?.withRenderingMode(.alwaysOriginal)

        let insets = UIEdgeInsets(top: 15, left: 12, bottom: 12, right: 12)
        firstVC.tabBarItem.imageInsets = insets
        secondVC.tabBarItem.imageInsets = insets
        chartsVC.tabBarItem.imageInsets = insets
        profileVC.tabBarItem.imageInsets = insets

        tabbar.viewControllers = [firstVC, secondVC, chartsVC, profileVC]

        window.rootViewController = tabbar
        // 將 UIWindow 設置為可見的
        window.makeKeyAndVisible()
    }

    static func showSinginScreen(window: UIWindow) {
        // 创建登录界面的视图控制器，这可以是你的登录页面
        let singinViewController = SignInViewController()

        // 创建一个导航控制器，如果需要的话
        let navigationController = UINavigationController(rootViewController: singinViewController)

        // 设置窗口的根视图控制器为导航控制器
        window.rootViewController = navigationController

        // 显示窗口
        window.makeKeyAndVisible()
    }
}
